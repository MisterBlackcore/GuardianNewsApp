//
//  NewsFeedViewModel.swift
//  GuardianNewsApp
//
//  Created by Interexy on 9.12.25.
//

import SwiftUI
import Combine

@MainActor
final class NewsFeedViewModel: ObservableObject {
    
    @Published var feedItemsToShow: [FeedItem] = []
    @Published var selectedOption: NewsFeedOption = .all
    @Published var error: NewsApiError?
    @Published var blockError: String?
    @Published var urlToOpen: String?
    @Published private var allFeedItems: [FeedItem] = []
    
    private var cachedNavigationResult: [NavigationResult]?
    private var cancellables = Set<AnyCancellable>()
    private var pageNumber = 1
    private let navigationBlockStep = 3
    private let pageSize = 20
    private let storage = SwiftDataStorage.shared 
    
    init() {
        Publishers
            .CombineLatest($allFeedItems, $selectedOption)
            .map { [weak self] allItems, option in
                switch option {
                case .all:
                    return allItems
                case .favorites:
                    return self?.storage.favoriteArticles ?? []
                case .blocked:
                    return self?.storage.blockedArticles  ?? []
                }
            }
            .assign(to: &$feedItemsToShow)
    }
    
    func loadFeed(reset: Bool = true) {
        if reset {
            pageNumber = 1
            allFeedItems = []
        }
        error = nil
        
        if let cachedNavigationResult {
            loadArticles(with: cachedNavigationResult, reset: reset)
            return
        }
        
        let navigationPublisher = NetworkClient.shared.request(.navigation)
            .map { (result: NavigationResults) in
                result.results
            }
            .handleEvents(receiveOutput: { [weak self] results in
                self?.cachedNavigationResult = results
            })
            .catch { [weak self] error -> Just<[NavigationResult]> in
                self?.parseError(from: error)
                return Just([])
            }
            .eraseToAnyPublisher()
        
        let articlesPublisher = NetworkClient.shared.request(.guardian(page: pageNumber, pageSize: pageSize))
            .map { (response: GuardianResponse) in
                response.response.results
            }
            .catch { [weak self] error -> Just<[GuardianArticle]> in
                self?.parseError(from: error)
                return Just([])
            }
            .eraseToAnyPublisher()
        
        Publishers.Zip(navigationPublisher, articlesPublisher)
            .compactMap { [weak self] navigationItems, articles in
                self?.createCompleteFeed(navigation: navigationItems, articles: articles, reset: reset)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newFeed in
                guard let self else { return }
                if reset {
                    self.allFeedItems = newFeed
                } else {
                    self.allFeedItems.append(contentsOf: newFeed)
                }
                if selectedOption == .all {
                    self.feedItemsToShow = allFeedItems
                }
            }
            .store(in: &cancellables)
    }
    
    func loadNextPage() {
        pageNumber += 1
        if let cachedNavigationResult {
            loadArticles(with: cachedNavigationResult, reset: false)
        } else {
            loadFeed(reset: false)
        }
    }
    
    private func loadArticles(with navigationResult: [NavigationResult], reset: Bool) {
        NetworkClient.shared.request(.guardian(page: pageNumber, pageSize: pageSize))
            .map { (response: GuardianResponse) in
                response.response.results
            }
            .catch { [weak self] error -> Just<[GuardianArticle]> in
                self?.parseError(from: error)
                return Just([])
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] articles in
                guard let self else { return }
                let newItems = self.createCompleteFeed(navigation: navigationResult, articles: articles, reset: reset)
                
                if reset {
                    self.allFeedItems = newItems
                } else {
                    self.allFeedItems.append(contentsOf: newItems)
                }
                if selectedOption == .all {
                    self.feedItemsToShow = allFeedItems
                }
            }
            .store(in: &cancellables)
    }
    
    private func parseError(from error: Error) {
        if let apiError = error as? NewsApiError {
            self.error = apiError
        } else {
            self.error = NewsApiError(reason: error.localizedDescription)
        }
    }
    
    private func createCompleteFeed(navigation: [NavigationResult], articles: [GuardianArticle], reset: Bool) -> [FeedItem] {
        reset ? createFeedFromScratch(navigation: navigation, articles: articles) : createFeedWithContinuation(navigation: navigation, articles: articles)
    }
    
    private func createFeedFromScratch(navigation: [NavigationResult], articles: [GuardianArticle]) -> [FeedItem] {
        var feed: [FeedItem] = []
        var navigationItemIndex = 0
        var articleCount = 0
        
        for article in articles {
            feed.append(.newsItem(article))
            articleCount += 1
            if navigationItemIndex < navigation.count && articleCount % navigationBlockStep == 0 {
                feed.append(.navigationBlock(navigation[navigationItemIndex]))
                navigationItemIndex += 1
            }
        }
        return feed
    }
    
    private func createFeedWithContinuation(navigation: [NavigationResult], articles: [GuardianArticle]) -> [FeedItem] {
        let currentArticlesCount = allFeedItems.filter {
            if case .newsItem = $0 {
                return true
            } else {
                return false
            }
        }.count
        
        let insertedNavigationCount = allFeedItems.filter {
            if case .navigationBlock = $0 {
                return true
            } else {
                return false
            }
        }.count
        
        var feed: [FeedItem] = []
        var navigationIndex = insertedNavigationCount
        var articleCount = currentArticlesCount
        
        for article in articles {
            feed.append(.newsItem(article))
            articleCount += 1
            if navigationIndex < navigation.count && articleCount % navigationBlockStep == 0 {
                feed.append(.navigationBlock(navigation[navigationIndex]))
                navigationIndex += 1
            }
        }
        return feed
    }
    
    func updateItem(item: GuardianArticle) {
        if let index = allFeedItems.firstIndex(where: { feedItem in
            if case .newsItem(let article) = feedItem {
                return article.id == item.id
            }
            return false
        }) {
            if case .newsItem(var article) = allFeedItems[index] {
                article.favorite = item.favorite
                article.blocked = item.blocked
                allFeedItems[index] = .newsItem(article)
                storage.saveOrUpdateArticle(article)
            }
        } else {
            storage.saveOrUpdateArticle(item)
        }

        selectedOption = selectedOption
    }

}

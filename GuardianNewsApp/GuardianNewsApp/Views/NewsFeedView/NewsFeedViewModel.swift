//
//  NewsFeedViewModel.swift
//  GuardianNewsApp
//
//  Created by Interexy on 9.12.25.
//

import SwiftUI
import Combine

enum BlockOption {
    case idBlock
    case newsSource
}

@MainActor
final class NewsFeedViewModel: ObservableObject {
    
    @Published var feedItemsToShow: [FeedItem] = []
    @Published var selectedOption: NewsFeedOption = .all
    @Published var overlayError: AppOverlayError?
    @Published var loading = false

    func handle(apiError: NewsApiError) {
        overlayError = AppOverlayError(alertStyle: .oneButton, title: apiError.error.reason)
    }

    @Published var urlToOpen: String?
    @Published private var allFeedItems: [FeedItem] = []
    
    private var cachedNavigationResult: [NavigationResult]?
    private var cancellables = Set<AnyCancellable>()
    private var pageNumber = 1
    private let navigationBlockStep = 3
    private let pageSize = 20
    private let storage = SwiftDataStorage.shared
    private var blockOption: BlockOption = .newsSource
    
    init() {
        Publishers.CombineLatest3(
            $allFeedItems,
            $selectedOption,
            storage.$blockedArticles
        )
        .map { [weak self] allItems, option, blockedItems in
            switch option {
            case .all:
                let newsArticles = allItems.compactMap { item -> GuardianArticle? in
                    if case .newsItem(let article) = item, article.blocked == false {
                        return article
                    }
                    return nil
                }
                return self?.buildFeed(articles: newsArticles, navigation: self?.cachedNavigationResult ?? []) ?? []
            case .favorites:
                return self?.storage.favoriteArticles ?? []
            case .blocked:
                return blockedItems
            }
        }
        .assign(to: &$feedItemsToShow)
    }
    
    func loadFeed(reset: Bool = true) {
        if reset {
            pageNumber = 1
            allFeedItems = []
        }
        loading = true
        overlayError = nil
        
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
                createNewFeed(reset: reset, newItems: newFeed)
                self.loading = false
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
                self.loading = false
                createNewFeed(reset: reset, newItems: newItems)
            }
            .store(in: &cancellables)
    }
    
    private func createNewFeed(reset: Bool, newItems: [FeedItem]) {
        let syncedItems = createSyncedFeedFromStorage(from: newItems)
        if reset {
            self.allFeedItems = syncedItems
        } else {
            self.allFeedItems.append(contentsOf: syncedItems)
        }
    }
    
    private func createSyncedFeedFromStorage(from feed: [FeedItem]) -> [FeedItem] {
        let blockedSources = storage.getBlockedSources()
        let syncedFeed = feed.map { feedItem -> FeedItem in
            switch feedItem {
            case .newsItem(let article):
                switch blockOption {
                case .idBlock:
                    if let saved = storage.getArticleIfSaved(by: article.id) {
                        var updatedArticle = article
                        updatedArticle.blocked = saved.blocked
                        updatedArticle.favorite = saved.favorite
                        return .newsItem(updatedArticle)
                    }
                    return feedItem
                case .newsSource:
                    var updatedArticle = article
                    if let saved = storage.getArticleIfSaved(by: article.id) {
                        updatedArticle.favorite = saved.favorite
                    }
                    if blockedSources.contains(article.sectionName ?? "") {
                        updatedArticle.blocked = true
                    }
                    return .newsItem(updatedArticle)
                }
            case .navigationBlock:
                return feedItem
            }
        }
        return syncedFeed
    }
    
    private func parseError(from error: Error) {
        loading = false
        if let apiError = error as? NewsApiError {
            handle(apiError: apiError)
        } else {
            handle(apiError: NewsApiError(reason: error.localizedDescription))
        }
    }
    
    private func createCompleteFeed(navigation: [NavigationResult], articles: [GuardianArticle], reset: Bool) -> [FeedItem] {
        reset ? buildFeed(articles: articles, navigation: navigation) : createFeedWithContinuation(navigation: navigation, articles: articles)
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

        return buildFeed(articles: articles, navigation: navigation, startArticleCount: currentArticlesCount, startNavigationIndex: insertedNavigationCount)
    }

    private func buildFeed(articles: [GuardianArticle], navigation: [NavigationResult], startArticleCount: Int = 0, startNavigationIndex: Int = 0) -> [FeedItem] {
        var feed: [FeedItem] = []
        var navigationIndex = startNavigationIndex
        var articleCount = startArticleCount

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
        switch blockOption {
        case .idBlock:
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
        case .newsSource:
            storage.saveOrUpdateArticle(item)
            let sectionName = item.sectionName
            allFeedItems = allFeedItems.map { feedItem in
                switch feedItem {
                case .newsItem(var article):
                    if article.sectionName == sectionName {
                        article.blocked = storage.getBlockedSources().contains(sectionName ?? "")
                        article.favorite = item.favorite
                    }
                    return .newsItem(article)
                case .navigationBlock:
                    return feedItem
                }
            }
        }
    }
}

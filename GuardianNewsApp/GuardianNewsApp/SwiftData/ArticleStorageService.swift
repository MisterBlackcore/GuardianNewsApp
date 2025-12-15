//
//  ArticleStorageService.swift
//  GuardianNewsApp
//
//  Created by Interexy on 11.12.25.
//

import SwiftData
import SwiftUI
import Combine

@MainActor
final class SwiftDataStorage: ObservableObject {
    
    static let shared = SwiftDataStorage()

    @Published private var savedArticles: [GuardianArticleData] = []
    @Published var favoriteArticles: [FeedItem] = []
    @Published var blockedArticles: [FeedItem] = []

    private var container: ModelContainer?

    init() {
        setupContainer()
        fetchSavedArticles()
    }

    private func setupContainer() {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: false)
            container = try ModelContainer(for: GuardianArticleData.self, configurations: config)
        } catch {
            container = nil
        }
    }

    private var modelContext: ModelContext? {
        container?.mainContext
    }

    func saveOrUpdateArticle(_ article: GuardianArticle) {
        do {
            if let existing = fetchArticleById(article.id) {
                if article.favorite == false && article.blocked == false {
                    deleteArticle(existing)
                } else {
                    updateArticle(existing, with: article)
                }
            } else {
                insertArticle(article)
            }
        }
    }

    private func fetchArticleById(_ id: String) -> GuardianArticleData? {
        guard let context = modelContext else { return nil }
        let descriptor = FetchDescriptor<GuardianArticleData>(
            predicate: #Predicate { $0.id == id }
        )
        return try? context.fetch(descriptor).first
    }

    private func updateArticle(_ model: GuardianArticleData, with article: GuardianArticle) {
        guard let context = modelContext else { return }

        model.favorite = article.favorite
        model.blocked = article.blocked
        model.webTitle = article.webTitle
        model.webUrl = article.webUrl
        model.sectionId = article.sectionId
        model.sectionName = article.sectionName
        model.type = article.type
        model.webPublicationDate = article.webPublicationDate

        do {
            try context.save()
            fetchSavedArticles()
        } catch {
            print(error.localizedDescription)
        }
    }

    private func insertArticle(_ article: GuardianArticle) {
        guard let context = modelContext else { return }

        let newModel = GuardianArticleData(with: article)
        context.insert(newModel)

        do {
            try context.save()
            fetchSavedArticles()
        } catch {
            print(error.localizedDescription)
        }
    }

    func deleteArticle(_ article: GuardianArticleData) {
        guard let context = modelContext else { return }

        do {
            context.delete(article)
            try context.save()
            fetchSavedArticles()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getBlockedSources() -> [String] {
        savedArticles
            .filter { $0.blocked == true }
            .map { $0.sectionName }
    }
    
    func getArticleIfSaved(by id: String) -> GuardianArticleData? {
        return savedArticles.first { $0.id == id }
    }

    private func fetchSavedArticles() {
        guard let context = modelContext else {
            savedArticles = []
            return
        }
        do {
            let descriptor = FetchDescriptor<GuardianArticleData>(
                sortBy: [SortDescriptor(\.webPublicationDate, order: .reverse)]
            )
            savedArticles = try context.fetch(descriptor)
            print("Articles number", savedArticles.count)
        } catch {
            savedArticles = []
        }
        makeFavoriteFeedItems()
        makeBlockedFeedItems()
    }
    
    private func makeFavoriteFeedItems() {
        favoriteArticles = savedArticles
                                .filter {
                                    $0.favorite == true
                                }
                                .sorted {
                                    $0.webPublicationDate > $1.webPublicationDate
                                }
                                .map {
                                    FeedItem.newsItem($0.getStruct())
                                }
    }
    
    private func makeBlockedFeedItems() {
        blockedArticles = savedArticles
                                .filter {
                                    $0.blocked == true
                                }
                                .sorted {
                                    $0.webPublicationDate > $1.webPublicationDate
                                }
                                .map {
                                    FeedItem.newsItem($0.getStruct())
                                }
    }
}

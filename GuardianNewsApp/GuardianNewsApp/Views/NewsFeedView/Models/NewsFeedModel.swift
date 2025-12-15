//
//  NewsFeedModel.swift
//  GuardianNewsApp
//
//  Created by Interexy on 9.12.25.
//

import SwiftUI

enum FeedItem: Identifiable {
    case newsItem(GuardianArticle)
    case navigationBlock(NavigationResult)
    
    var id: String {
        switch self {
        case .newsItem(let article):
            return article.id
        case .navigationBlock(let navigationModel):
            return "navigationModel-\(navigationModel.id)"
        }
    }
    
    func getArticle() -> GuardianArticle? {
        switch self {
        case .newsItem(let guardianArticle):
            return guardianArticle
        default:
            return nil
        }
    }
}

enum NewsFeedOption: String, CaseIterable, Identifiable {
    case all = "All"
    case favorites = "Favorites"
    case blocked = "Blocked"
    
    var id: Self { self }
    
    func getTitle() -> String {
        switch self {
        case .all:
            return ""
        case .favorites:
            return "No Favorite News"
        case .blocked:
            return "No Blocked News"
        }
    }
    
    func getIconName() -> String {
        switch self {
        case .all:
            return ""
        case .favorites:
            return AppImageService.noFavoriteArticlesIcon.rawValue
        case .blocked:
            return AppImageService.noBlockedArticlesIcon.rawValue
        }
    }
}


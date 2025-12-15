//
//  FeedItem.swift
//  GuardianNewsApp
//
//  Created by Interexy on 16.12.25.
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

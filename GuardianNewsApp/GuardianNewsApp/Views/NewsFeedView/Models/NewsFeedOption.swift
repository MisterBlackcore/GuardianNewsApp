//
//  NewsFeedOption.swift
//  GuardianNewsApp
//
//  Created by Interexy on 16.12.25.
//

import SwiftUI

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

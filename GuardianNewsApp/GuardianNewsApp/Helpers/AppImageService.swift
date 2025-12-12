//
//  AppImageService.swift
//  GuardianNewsApp
//
//  Created by Interexy on 10.12.25.
//

import SwiftUI

enum AppImageService: String {
    // MARK: - Icons
    
    // MARK: - EmptyViewIcons
    case noBlockedArticlesIcon = "noBlockedArticlesIcon"
    case noFavoriteArticlesIcon = "noFavoriteArticlesIcon"
    
    // MARK: - Context Menu
    case contextMenuIcon = "contextMenuIcon"
    case blockActionIcon = "blockActionIcon"
    case unblockActionIcon = "unblockActionIcon"
    case addToFavoriteIcon = "addToFavoriteIcon"
    case removeFromFavoriteIcon = "removeFromFavoriteIcon"
    case closeScreenIcon = "closeScreenIcon"
    
    // MARK: - Placeholders
    case emptyNewsPlaceholder = "emptyNewsPlaceholder"
}

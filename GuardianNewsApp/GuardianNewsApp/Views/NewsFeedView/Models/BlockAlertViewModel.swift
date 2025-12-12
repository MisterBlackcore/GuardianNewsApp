//
//  BlockAlertViewModel.swift
//  GuardianNewsApp
//
//  Created by Interexy on 12.12.25.
//

import SwiftUI

enum BlockAlertViewModel: Identifiable {
    
    var id: String {
        switch self {
        case .block(let article):
            return "block-\(article.id)"
        case .unblock(let article):
            return "unblock-\(article.id)"
        }
    }
    
    case block(GuardianArticle)
    case unblock(GuardianArticle)
    
    func getTitle() -> String {
        switch self {
        case .block:
            return "Do you want to block?"
        case .unblock:
            return "Do you want to unblock?"
        }
    }
    
    func getDescription() -> String {
        switch self {
        case .block:
            return "Confirm to hide this news source"
        case .unblock:
            return "Confirm to unblock this news source"
        }
    }
    
    func getActionButton() -> String {
        switch self {
        case .block:
            return "Block"
        case .unblock:
            return "Unblock"
        }
    }
    
    func getCancelButton() -> String {
        switch self {
        default:
            return "Cancel"
        }
    }
    
    func getArticle() -> GuardianArticle {
        switch self {
        case .block(let article):
            return article
        case .unblock(let article):
            return article
        }
    }
}

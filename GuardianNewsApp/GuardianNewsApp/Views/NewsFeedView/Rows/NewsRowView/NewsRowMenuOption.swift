//
//  NewsRowMenuOption.swift
//  GuardianNewsApp
//
//  Created by Interexy on 16.12.25.
//

import SwiftUI

enum NewsRowMenuOption {
    case favorite(Bool)
    case block(Bool)
    
    var rowButtonText: String {
        switch self {
        case .favorite(let add):
            return add ? "Add to Favorites" : "Remove from Favorites"
        case .block(let block):
            return block ? "Block" : "Unblock"
        }
    }
    
    var imageName: String {
        switch self {
        case .favorite(let add):
            return add
                ? AppImageService.addToFavoriteIcon.rawValue
                : AppImageService.removeFromFavoriteIcon.rawValue
        case .block(let block):
            return block
                ? AppImageService.blockActionIcon.rawValue
                : AppImageService.unblockActionIcon.rawValue
        }
    }
    
    var value: Bool {
        switch self {
        case .favorite(let add):
            return add
        case .block(let block):
            return block
        }
    }
    
    var alertTitle: String {
        switch self {
        case .block(let bool):
            return bool ? "Do you want to block?" : "Do you want to unblock?"
        default:
            return ""
        }
    }
    
    var alertDescription: String {
        switch self {
        case .block(let bool):
            return bool ? "Confirm to hide this news source" : "Confirm to unblock this news source"
        default:
            return ""
        }
    }
    
    var alertActionButton: String {
        switch self {
        case .block(let bool):
            return bool ? "Block" : "Unblock"
        default:
            return ""
        }
    }
}

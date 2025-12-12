//
//  NavigationResults.swift
//  GuardianNewsApp
//
//  Created by Interexy on 9.12.25.
//

struct NavigationResults: Decodable {
    let results: [NavigationResult]
}

struct NavigationResult: Decodable, Identifiable, Hashable {
    let id: Int
    let title: String
    let subtitle: String?
    let title_symbol: String?
    let button_title: String?
    let button_symbol: String?
    let navigation: NavigationResultType
}

enum NavigationResultType: String, Decodable {
    case push
    case modal
    case fullScreen = "full_screen"
}


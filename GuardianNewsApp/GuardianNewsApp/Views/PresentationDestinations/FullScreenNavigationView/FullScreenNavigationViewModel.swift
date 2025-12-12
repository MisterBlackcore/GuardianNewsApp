//
//  FullScreenNavigationViewModel.swift
//  GuardianNewsApp
//
//  Created by Interexy on 11.12.25.
//


import SwiftUI
import Combine

final class FullScreenNavigationViewModel: ObservableObject {
    
    @Published var title: String
    @Published var subtitile: String
    
    init(model: NavigationResult) {
        self.title = model.title
        self.subtitile = model.subtitle ?? "No subtitile"
    }
}

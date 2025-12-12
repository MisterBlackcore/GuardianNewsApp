//
//  SheetNavigationViewModel.swift
//  GuardianNewsApp
//
//  Created by Interexy on 10.12.25.
//

import SwiftUI
import Combine

final class SheetNavigationViewModel: ObservableObject {
    
    @Published var iconTitle: String?
    @Published var title: String
    
    init(model: NavigationResult) {
        self.iconTitle = model.title_symbol
        self.title = model.title
    }
}

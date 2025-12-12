//
//  PushNavigationViewModel.swift
//  GuardianNewsApp
//
//  Created by Interexy on 10.12.25.
//

import SwiftUI
import Combine

final class PushNavigationViewModel: ObservableObject {
    
    @Published var title: String
    @Published var subtitle: String
    
    init(model: NavigationResult) {
        self.title = model.title
        self.subtitle = model.subtitle ?? "No text"
    }
}

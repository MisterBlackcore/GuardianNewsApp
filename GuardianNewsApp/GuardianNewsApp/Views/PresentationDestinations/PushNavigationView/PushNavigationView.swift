//
//  PushNavigationView.swift
//  GuardianNewsApp
//
//  Created by Interexy on 10.12.25.
//

import SwiftUI

struct PushNavigationView: View {
    
    @StateObject var viewModel: PushNavigationViewModel
    
    init(model: NavigationResult) {
        _viewModel = StateObject(wrappedValue: PushNavigationViewModel(model: model))
    }
    
    var body: some View {
        VStack {
            Text(viewModel.subtitle)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.projectGrey)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.projectBeige)
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}


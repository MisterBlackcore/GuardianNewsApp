//
//  SheetNavigationView.swift
//  GuardianNewsApp
//
//  Created by Interexy on 10.12.25.
//

import SwiftUI

struct SheetNavigationView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject var viewModel: SheetNavigationViewModel
    
    init(model: NavigationResult) {
        _viewModel = StateObject(wrappedValue: SheetNavigationViewModel(model: model))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: dismissScreen) {
                    Image(AppImageService.closeScreenIcon)
                        .frame(width: 23, height: 23)
                }
                
                Spacer()
            }
            .frame(height: 45)
            .padding(.horizontal, 16)
            
            VStack(alignment: .center, spacing: 8) {
                if let iconTitle = viewModel.iconTitle {
                    Image(systemName: iconTitle)
                        .resizable()
                        .foregroundColor(.projectBlue)
                        .frame(width: 48, height: 48)
                }

                Text(viewModel.title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.projectBlack)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.projectWhite)
    }
    
    private func dismissScreen() {
        presentationMode.wrappedValue.dismiss()
    }
}


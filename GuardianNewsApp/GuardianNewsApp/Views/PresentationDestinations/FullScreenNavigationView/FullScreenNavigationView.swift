//
//  FullScreenNavigationView.swift
//  GuardianNewsApp
//
//  Created by Interexy on 11.12.25.
//


import SwiftUI

struct FullScreenNavigationView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject var viewModel: FullScreenNavigationViewModel
    
    init(model: NavigationResult) {
        _viewModel = StateObject(wrappedValue: FullScreenNavigationViewModel(model: model))
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
                Text(viewModel.title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.projectBlack)
                
                Text(viewModel.subtitile)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.projectGrey)
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

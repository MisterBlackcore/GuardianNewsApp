//
//  RefreshFeedView.swift
//  GuardianNewsApp
//
//  Created by Interexy on 12.12.25.
//

import SwiftUI

struct RefreshFeedView: View {
    
    let refresh: ()->()
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image(AppImageService.loadArticlesErrorIcon)
                .resizable()
                .frame(width: 48, height: 48)
                .padding(.bottom, 8)

            Text("No Results")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.projectBlack)
                .padding(.bottom, 12)
            
            Button(action: refreshAction) {
                ZStack(alignment: .center) {
                    Text("Refresh")
                        .foregroundColor(.projectWhite)
                        .font(.system(size: 17, weight: .bold))
                    
                    
                    HStack {
                        Spacer()
                        Image(AppImageService.refreshButtonIcon)
                            .frame(width: 24, height: 24)
                    }
                    .padding(.horizontal, 16)
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
            }
            .background(Color.projectBlue)
            .cornerRadius(4)
            .padding(.horizontal, 16)
        }
    }
    
    private func refreshAction() {
        refresh()
    }
}

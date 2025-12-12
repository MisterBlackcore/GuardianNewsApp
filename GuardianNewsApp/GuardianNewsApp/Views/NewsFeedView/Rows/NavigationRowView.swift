//
//  NavigationRowView.swift
//  GuardianNewsApp
//
//  Created by Interexy on 10.12.25.
//

import SwiftUI

struct NavigationRowView: View {
    
    let navigationModel: NavigationResult
    let buttonAction: (NavigationResult) -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if let iconTitle = navigationModel.title_symbol {
                Image(systemName: iconTitle)
                    .resizable()
                    .foregroundColor(.projectBlue)
                    .frame(width: 24, height: 24)
                    .padding(.bottom, 8)
            }
            
            Text(navigationModel.title)
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.projectBlack)
                .padding(.bottom, 8)
            
            if let subtitle = navigationModel.subtitle {
                Text(subtitle)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.projectGrey)
                    .padding(.bottom, 12)
            }
            
            if let buttonTitle = navigationModel.button_title {
                Button(action: navigationAction) {
                    ZStack(alignment: .center) {
                        Text(buttonTitle)
                            .foregroundColor(.projectWhite)
                            .font(.system(size: 17, weight: .bold))
                        
                        
                        if let buttonSymbol = navigationModel.button_symbol {
                            HStack {
                                Spacer()
                                Image(systemName: buttonSymbol)
                                    .foregroundColor(.projectWhite)
                                    .frame(width: 24, height: 24)
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
                }
                .background(Color.projectBlue)
                .cornerRadius(4)
                .padding(.horizontal, 16)
            }
        }
        .frame(height: 141)
    }
    
    private func navigationAction() {
        buttonAction(navigationModel)
    }
}

#Preview {
    NewsFeedView()
}

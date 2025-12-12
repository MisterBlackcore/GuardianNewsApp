//
//  FeedEmptyView.swift
//  GuardianNewsApp
//
//  Created by Interexy on 11.12.25.
//

import SwiftUI

struct FeedEmptyView: View {
    
    let option: NewsFeedOption
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(option.getIconName())
                .resizable()
                .frame(width: 48, height: 48)

            Text(option.getTitle())
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.projectBlack)
        }
    }
}

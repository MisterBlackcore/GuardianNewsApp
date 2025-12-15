//
//  NewsRowView.swift
//  GuardianNewsApp
//
//  Created by Interexy on 10.12.25.
//

import SwiftUI

struct NewsRowView: View {    
    @State var articleModel: GuardianArticle
    @Binding var alert: AppOverlayError?
    let rowOption: NewsFeedOption
    let buttonAction: (GuardianArticle) -> Void
    
    private var favoriteOption: NewsRowMenuOption {
        NewsRowMenuOption.favorite(articleModel.favorite == false)
    }
    
    private var blockedOption: NewsRowMenuOption {
        NewsRowMenuOption.block(articleModel.blocked == false)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Image(AppImageService.emptyNewsPlaceholder)
                .resizable()
                .frame(width: 86)
                .frame(maxHeight: .infinity)
                .cornerRadius(4)
                .padding(.trailing, 8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(articleModel.webTitle ?? "News title")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.projectBlack)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(articleModel.getBottomText())
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.projectGrey)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.trailing, 12)
            
            VStack {
                Menu {
                    if rowOption != .blocked {
                        Button(action: toggleFavorite) {
                            Label(favoriteOption.rowButtonText, image: favoriteOption.imageName)
                        }
                    }

                    Button(role: .destructive, action: toogleBlock) {
                        Label(blockedOption.rowButtonText, image: blockedOption.imageName)
                    }
                } label: {
                    Image(AppImageService.contextMenuIcon)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
    }
    
    private func toggleFavorite() {
        articleModel.favorite?.toggle()
        buttonAction(articleModel)
    }
    
    private func toogleBlock() {
        alert = AppOverlayError(alertStyle: .twoButton,
                                    title: blockedOption.alertTitle,
                                    description: blockedOption.alertDescription,
                                    actionTitle: blockedOption.rowButtonText,
                                    secondButtonTitle: "Cancel") {
            articleModel.blocked?.toggle()
            buttonAction(articleModel)
        }
    }
}

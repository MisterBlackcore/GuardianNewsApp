//
//  NewsRowView.swift
//  GuardianNewsApp
//
//  Created by Interexy on 10.12.25.
//

import SwiftUI

struct NewsRowView: View {
    
    @State var articleModel: GuardianArticle
    @State var blockAlert: BlockAlertViewModel?
    @State var showingAlert = false
    let rowOption: NewsFeedOption
    let buttonAction: (GuardianArticle) -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            Image(AppImageService.emptyNewsPlaceholder)
                .resizable()
                .frame(width: 86)
                .frame(maxHeight: .infinity)
                .cornerRadius(4)
                .padding(.trailing, 8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(articleModel.webTitle)
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
                            Label(
                                articleModel.favorite == false ? "Add to Favorites" : "Remove from Favorites",
                                image: articleModel.favorite == false ? .addToFavoriteIcon : .removeFromFavoriteIcon
                            )
                        }
                    }
                    
                    Button(role: .destructive) {
                        showingAlert = true
                        blockAlert = articleModel.blocked == false
                            ? .block(articleModel)
                            : .unblock(articleModel)
                    } label: {
                        Label(
                            articleModel.blocked == false ? "Block" : "Unblock",
                            image: articleModel.blocked == false ? .blockActionIcon : .unblockActionIcon
                        )
                    }
                } label: {
                    Image(AppImageService.contextMenuIcon)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                
                Spacer()
            }
        }
        .alert(blockAlert?.getTitle() ?? "", isPresented: $showingAlert) {
            Button(blockAlert?.getActionButton() ?? "", role: .destructive) {
                toogleBlock()
                blockAlert = nil
            }
            Button(blockAlert?.getCancelButton() ?? "", role: .cancel) {
                blockAlert = nil
            }
        } message: {
            Text(blockAlert?.getDescription() ?? "")
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
        articleModel.blocked?.toggle()
        buttonAction(articleModel)
    }
}

//
//  NewsFeedView.swift
//  GuardianNewsApp
//
//  Created by Interexy on 9.12.25.
//

import SwiftUI

struct NewsFeedView: View {
    
    @StateObject private var viewModel = NewsFeedViewModel()
    @State private var pushNavigation: NavigationResult?
    @State private var modalNavigation: NavigationResult?
    @State private var fullScreenNavigation: NavigationResult?
    @State private var scrollViewHeight: CGFloat = 0

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 16) {
                        Picker("News", selection: $viewModel.selectedOption) {
                            ForEach(NewsFeedOption.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal, 16)
                        
                        if viewModel.feedItemsToShow.isEmpty {
                            VStack {
                                switch viewModel.selectedOption {
                                case .all:
                                    ProgressView()
                                        .scaleEffect(1.2)
                                        .padding()
                                default:
                                    FeedEmptyView(option: viewModel.selectedOption)
                                }
                            }
                            .frame(minHeight: max(0, scrollViewHeight - 100))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            LazyVStack(spacing: 8) {
                                ForEach(viewModel.feedItemsToShow) { item in
                                    rowView(for: item)
                                        .onAppear {
                                            guard viewModel.selectedOption == .all else { return }
                                            if item.id == viewModel.feedItemsToShow.last?.id {
                                                viewModel.loadNextPage()
                                            }
                                        }
                                }
                            }
                            .padding(.horizontal, 16)
                            .background(Color.projectWhite)
                            .cornerRadius(8)
                        }
                    }
                    .padding(.vertical, 8)
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .onAppear {
                                    scrollViewHeight = geometry.size.height
                                }
                                .onChange(of: geometry.size.height) { _, newHeight in
                                    scrollViewHeight = newHeight
                                }
                        }
                    )
                }
                .scrollDisabled(viewModel.feedItemsToShow.isEmpty)
                .refreshable {
                    await Task {
                        viewModel.loadFeed(reset: true)
                    }.value
                }
                .background(Color.projectBeige)
            }
            .navigationTitle("News Feed")
            .onAppear {
                if viewModel.feedItemsToShow.isEmpty {
                    viewModel.loadFeed()
                }
            }
            .navigationDestination(item: $pushNavigation) { model in
                PushNavigationView(model: model)
            }
            .sheet(item: $modalNavigation) { model in
                SheetNavigationView(model: model)
            }
            .fullScreenCover(item: $fullScreenNavigation) { model in
                FullScreenNavigationView(model: model)
            }
            .alert(item: $viewModel.error) { error in
                Alert(
                    title: Text(error.error.reason),
                    dismissButton: .default(Text("OK")) {
                        viewModel.error = nil
                    }
                )
            }
            .navigationDestination(item: $viewModel.urlToOpen) { url in
                WebView(stringUrl: url)
            }
        }
    }

    @ViewBuilder
    private func rowView(for item: FeedItem) -> some View {
        switch item {
        case .newsItem(let article):
            NewsRowView(
                articleModel: article,
                rowOption: viewModel.selectedOption,
                buttonAction: viewModel.updateItem
            )
            .frame(height: 110)
            .onTapGesture {
                viewModel.urlToOpen = article.webUrl
            }
        case .navigationBlock(let navigationModel):
            NavigationRowView(navigationModel: navigationModel, buttonAction: handleNavigation)
        }
    }

    private func handleNavigation(navigationItem: NavigationResult) {
        switch navigationItem.navigation {
        case .push:
            pushNavigation = navigationItem
        case .modal:
            modalNavigation = navigationItem
        case .fullScreen:
            fullScreenNavigation = navigationItem
        }
    }
}

#Preview {
    NewsFeedView()
}




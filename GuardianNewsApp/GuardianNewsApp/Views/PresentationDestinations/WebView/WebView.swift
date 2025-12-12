//
//  WebView.swift
//  GuardianNewsApp
//
//  Created by Interexy on 12.12.25.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    let stringUrl: String
    
    init(stringUrl: String) {
        self.stringUrl = stringUrl
    }
    
    func makeUIView(context: Context) -> some UIView {
        let webView = WKWebView()
        guard let url = URL(string: stringUrl) else {
            return webView
        }
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

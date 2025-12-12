//
//  NewsAPI.swift
//  GuardianNewsApp
//
//  Created by Interexy on 9.12.25.
//


import Foundation

enum NewsAPI {
    case navigation
    case guardian(page: Int?, pageSize: Int?)
}

extension NewsAPI {

    var baseURL: URL? {
        URL(string: "https://us-central1-server-side-functions.cloudfunctions.net")
    }

    var path: String {
        switch self {
        case .navigation: 
            return "/navigation"
        case .guardian:  
            return "/guardian"
        }
    }

    var method: String {
        switch self {
        default:
            return "GET"
        }
    }

    var headers: [String: String] {
        [
            "Authorization": "anton-shkuray",
            "Content-Type": "application/json"
        ]
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .navigation:
            return nil
        case let .guardian(page, pageSize):
            var items: [URLQueryItem] = []
            if let page {
                items.append(.init(name: "page", value: "\(page)"))
            }
            if let pageSize {
                items.append(.init(name: "page-size", value: "\(pageSize)"))
            }
            return items.isEmpty ? nil : items
        }
    }

    func makeURLRequest() -> URLRequest? {
        guard let baseURL,
              var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            return nil
        }
        components.queryItems = queryItems
        
        guard let url = components.url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}

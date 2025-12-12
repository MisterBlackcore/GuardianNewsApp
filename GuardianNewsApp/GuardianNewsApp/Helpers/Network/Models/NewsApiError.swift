//
//  NewsApiError.swift
//  GuardianNewsApp
//
//  Created by Interexy on 9.12.25.
//

struct NewsApiError: Decodable, Error, Identifiable {
    let error: NewsApiErrorContent
    
    var id: String {
        "\(error.statusCode)-\(error.reason)"
    }
    
    init(statusCode: Int = 0, reason: String = "Unrecognized error") {
        self.error = NewsApiErrorContent(statusCode: statusCode, reason: reason)
    }
}

struct NewsApiErrorContent: Decodable {
    let statusCode: Int
    let reason: String
}

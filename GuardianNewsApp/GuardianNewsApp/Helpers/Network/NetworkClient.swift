//
//  NetworkClient.swift
//  GuardianNewsApp
//
//  Created by Interexy on 9.12.25.
//


import Combine
import Foundation

final class NetworkClient {
    static let shared = NetworkClient()
    private init() {}

    private let session = URLSession.shared

    func request<T: Decodable>(_ api: NewsAPI) -> AnyPublisher<T, Error> {
        guard let request = api.makeURLRequest() else {
            return Fail(error: NewsApiError(statusCode: 0, reason: "Invalid URL"))
                .eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: request)
            .tryMap { data, _ -> T in
                print("RAW RESPONSE:")
                print(String(data: data, encoding: .utf8) ?? "❌ Unable to decode response")
                if let result = try? JSONDecoder().decode(T.self, from: data) {
                    return result
                }
                
                if let serverError = try? JSONDecoder().decode(NewsApiError.self, from: data) {
                    throw serverError
                }
                
                throw NewsApiError(statusCode: 0, reason: "Unknown response")
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

//
//  GuardianNewsApp.swift
//  GuardianNewsApp
//
//  Created by Interexy on 9.12.25.
//

import SwiftUI

@main
struct GuardianNewsApp: App {
    
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            NewsFeedView()
                .environmentObject(networkMonitor)
        }
    }
}

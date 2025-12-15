//
//  AppOverlayError.swift
//  GuardianNewsApp
//
//  Created by Interexy on 16.12.25.
//

import SwiftUI

struct AppOverlayError: Identifiable, Equatable {
    let id = UUID()
    var alertStyle: AlertStyle
    var title: String
    var description: String?
    var actionTitle: String = "OK"
    var secondButtonTitle: String? = nil
    var action: (() -> Void)? = nil
    
    static func == (lhs: AppOverlayError, rhs: AppOverlayError) -> Bool {
        lhs.id == rhs.id
    }
}

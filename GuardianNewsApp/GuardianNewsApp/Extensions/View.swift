//
//  View.swift
//  GuardianNewsApp
//
//  Created by Interexy on 16.12.25.
//

import SwiftUI

extension View {
    func overlayAlert(_ alert: Binding<AppOverlayError?>) -> some View {
        self.modifier(OverlayBlurAlertModifier(alert: alert))
    }
}

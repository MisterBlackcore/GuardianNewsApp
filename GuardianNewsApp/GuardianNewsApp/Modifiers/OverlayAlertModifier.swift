//
//  OverlayAlertModifier.swift
//  GuardianNewsApp
//
//  Created by Interexy on 16.12.25.
//

import SwiftUI

struct OverlayBlurAlertModifier: ViewModifier {
    @Binding var alert: AppOverlayError?

    func body(content: Content) -> some View {
        ZStack {
            content
            if alert != nil {
                BlurAlert(alert: $alert)
                    .transition(.opacity)
            }
        }
    }
}

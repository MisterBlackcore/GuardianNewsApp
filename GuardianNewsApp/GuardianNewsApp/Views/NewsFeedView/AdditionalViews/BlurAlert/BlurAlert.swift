//
//  BlurAlert.swift
//  GuardianNewsApp
//
//  Created by Interexy on 14.12.25.
//

import SwiftUI

enum AlertStyle {
    case oneButton
    case twoButton
}

struct BlurAlert: View {
    @Binding var alert: AppOverlayError?
    
    @State private var blurOpacity: Double = 0
    @State private var alertScale: CGFloat = 0.85
    @State private var alertOpacity: Double = 0
    
    var body: some View {
        if alert != nil {
            ZStack {
                VisualEffectBlur(blurStyle: .systemMaterialDark)
                    .ignoresSafeArea()
                    .opacity(blurOpacity)
                    .onTapGesture {
                        dismissAlert()
                    }
                
                VStack(spacing: 0) {
                    VStack(spacing: 6) {
                        Text(alert?.title ?? "")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                        
                        if let description = alert?.description {
                            Text(description)
                                .font(.system(size: 13))
                                .foregroundColor(.black.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.vertical, 18)
                    .padding(.horizontal, 16)
                    
                    Divider()
                    
                    
                    Button(action: firstButtonPressed) {
                        Text(alert?.actionTitle ?? "OK")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.projectBlue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                    }
                    
                    if alert?.secondButtonTitle != nil {
                        Divider()
                        
                        Button(action: secondButtonPressed) {
                            Text(alert?.secondButtonTitle ?? "")
                                .font(.system(size: 17))
                                .foregroundColor(.projectRed)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                        }
                    }
                }
                .background(Color.projectAlert)
                .cornerRadius(14)
                .scaleEffect(alertScale)
                .opacity(alertOpacity)
                .padding(.horizontal, 48)
            }
            .onAppear {
                showAnimation()
            }
            .transition(.opacity)
        }
    }

    private func showAnimation() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
            blurOpacity = 1
            alertScale = 1
            alertOpacity = 1
        }
    }
    
    private func dismissAlert() {
        withAnimation(.easeOut(duration: 0.25)) {
            blurOpacity = 0
            alertScale = 0.85
            alertOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            alert = nil
        }
    }
    private func firstButtonPressed() {
        dismissAlert()
        alert?.action?()
    }
    
    private func secondButtonPressed() {
        dismissAlert()
    }
}

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

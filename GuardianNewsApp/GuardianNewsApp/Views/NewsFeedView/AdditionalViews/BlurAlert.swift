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
    @Binding var isPresented: Bool
    let alertStyle: AlertStyle
    let title: String
    let description: String?
    let firstButtonTitle: String
    var firstButtonAction: (() -> ())?
    var secondButtonAction: (() -> ())?
    
    @State private var blurOpacity: Double = 0
    @State private var alertScale: CGFloat = 0.8
    @State private var alertOpacity: Double = 0
    
    var body: some View {
        if isPresented {
            ZStack {
                VisualEffectBlur(blurStyle: .systemMaterialDark)
                    .ignoresSafeArea()
                    .opacity(blurOpacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            blurOpacity = 1
                        }
                    }
                    .onDisappear {
                        blurOpacity = 0
                    }
                VStack(spacing: 0) {
                    VStack(spacing: 2) {
                        Text(title)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.black)
                        
                        if let description {
                            Text(description)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.vertical, 18)
                    .padding(.horizontal, 16)
                    
                    Divider()
                    
                    Button(action: firstButtonIsPressed) {
                        Text(firstButtonTitle)
                            .foregroundColor(.projectWhite)
                            .font(.system(size: 17, weight: .bold))
                    }
                    .frame(height: 44)
                    
                    Divider()
                    
                    if alertStyle == .twoButton {
                        Divider()
                        
                        Button(action: secondButtonIsPressed) {
                            Text(title)
                                .foregroundColor(.projectWhite)
                                .font(.system(size: 17, weight: .bold))
                        }
                        .frame(height: 44)
                    }
                }
                .background(Color.projectAlert)
                .cornerRadius(14)
                .scaleEffect(alertScale)
                .opacity(alertOpacity)
                .padding(.horizontal, 62)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring(
                            response: 0.4,
                            dampingFraction: 0.6,
                            blendDuration: 0
                        )) {
                            alertScale = 1
                            alertOpacity = 1
                        }
                    }
                }
            }
            .transition(.opacity)
        }
    }
    
    private func dismissAlert() {
        withAnimation(.easeOut(duration: 0.2)) {
            alertScale = 0.8
            alertOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeOut(duration: 0.2)) {
                blurOpacity = 0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            isPresented = false
        }
    }
    
    private func firstButtonIsPressed() {
        isPresented = false
        firstButtonAction?()
    }
    
    private func secondButtonIsPressed() {
        isPresented = false
        secondButtonAction?()
    }
}

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

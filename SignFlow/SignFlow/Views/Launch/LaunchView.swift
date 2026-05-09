//
//  LaunchView.swift
//  SignFlow
//

import SwiftUI

struct LaunchView: View {
    let onFinished: () -> Void
    
    @State private var logoScale: CGFloat = 0.6
    @State private var contentOpacity: Double = 0
    @State private var ringRotation: Double = 0
    @State private var loadingPhase: CGFloat = 0
    @State private var shimmerX: CGFloat = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.05, blue: 0.10),
                    Color(red: 0.08, green: 0.10, blue: 0.18),
                    Color(red: 0.10, green: 0.11, blue: 0.20),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            Circle()
                .stroke(Color.white.opacity(0.16), lineWidth: 2)
                .frame(width: 250, height: 250)
                .rotationEffect(.degrees(ringRotation))
                .blur(radius: 0.5)
            
            VStack {
                Spacer()
                
                VStack(spacing: 8) {
                    Image("splash-Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                    
                    Text(AppConstants.appDisplayName)
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 10)
                .opacity(contentOpacity)
                
                Spacer(minLength: 120)
                
                bottomLoader
                    .padding(.bottom, 28)
                    .opacity(contentOpacity)
            }
            .padding(.horizontal, 24)
        }
        .onAppear {
            withAnimation(.spring(response: 0.9, dampingFraction: 0.72)) {
                logoScale = 1.0
            }
            withAnimation(.easeOut(duration: 0.9).delay(0.15)) {
                contentOpacity = 1
            }
            withAnimation(.linear(duration: 12).repeatForever(autoreverses: false)) {
                ringRotation = 360
            }
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                loadingPhase = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.95) {
                onFinished()
            }
        }
    }
    
    private var bottomLoader: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .tint(.white.opacity(0.9))
            .scaleEffect(1.1)
            .padding(.top, 4)
    }
}

#Preview {
    LaunchView {
        print("Launch Finished")
    }
}

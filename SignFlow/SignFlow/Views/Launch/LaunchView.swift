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
                .offset(y: 60)

            VStack {
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color.white.opacity(0.06))
                        .frame(width: 210, height: 110)
                        .overlay {
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        }
                        .offset(x: -54, y: -10)
                        .rotationEffect(.degrees(-9))

                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 170, height: 88)
                        .overlay {
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(Color.white.opacity(0.20), lineWidth: 1)
                        }
                        .offset(x: 58, y: 8)
                        .rotationEffect(.degrees(8))
                }
                .opacity(contentOpacity * 0.82)
                .padding(.bottom, 8)

                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 112, height: 112)
                        .overlay {
                            Circle()
                                .stroke(Color.white.opacity(0.35), lineWidth: 1)
                        }
                        .shadow(color: .black.opacity(0.18), radius: 20, x: 0, y: 12)

                    Image(systemName: "signature")
                        .font(.system(size: 44, weight: .medium))
                        .foregroundStyle(.white)
                        .symbolRenderingMode(.hierarchical)
                }
                .scaleEffect(logoScale)
                .padding(.top, 18)

                VStack(spacing: 8) {
                    Text(AppConstants.appDisplayName)
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    Text("Sign. Seal. Share.")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.78))
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

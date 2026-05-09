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
    @State private var shimmerX: CGFloat = -160

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
                .stroke(Color.white.opacity(0.20), lineWidth: 2)
                .frame(width: 250, height: 250)
                .rotationEffect(.degrees(ringRotation))
                .blur(radius: 0.5)

            VStack(spacing: 22) {
                ZStack {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color.white.opacity(0.06))
                        .frame(width: 210, height: 110)
                        .overlay {
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        }
                        .offset(x: -54, y: -12)
                        .rotationEffect(.degrees(-9))

                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 170, height: 88)
                        .overlay {
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        }
                        .offset(x: 64, y: 10)
                        .rotationEffect(.degrees(8))
                }
                .opacity(contentOpacity * 0.82)

                ZStack {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .frame(width: 112, height: 112)
                        .overlay {
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .stroke(Color.white.opacity(0.35), lineWidth: 1)
                        }
                        .shadow(color: .black.opacity(0.18), radius: 20, x: 0, y: 12)

                    Image(systemName: "signature")
                        .font(.system(size: 44, weight: .medium))
                        .foregroundStyle(.white)
                        .symbolRenderingMode(.hierarchical)
                }
                .scaleEffect(logoScale)

                VStack(spacing: 6) {
                    Text(AppConstants.appDisplayName)
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.white)
                    Text("Sign. Seal. Share.")
                        .font(Theme.captionFont)
                        .foregroundStyle(.white.opacity(0.85))
                }
                .opacity(contentOpacity)

                bottomLoader
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
            withAnimation(.linear(duration: 1.15).repeatForever(autoreverses: false)) {
                shimmerX = 160
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.95) {
                onFinished()
            }
        }
    }

    private var bottomLoader: some View {
        VStack(spacing: 10) {
            Text("Loading workspace…")
                .font(.system(.caption, design: .rounded).weight(.medium))
                .foregroundStyle(.white.opacity(0.75))

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.16))
                    .frame(width: 170, height: 8)

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.35), Color.white.opacity(0.95), Color.white.opacity(0.35)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 90, height: 8)
                    .offset(x: shimmerX)
                    .mask(
                        Capsule()
                            .frame(width: 170, height: 8)
                    )
            }
        }
        .padding(.top, 4)
    }
}


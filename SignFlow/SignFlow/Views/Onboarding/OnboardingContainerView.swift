//
//  OnboardingContainerView.swift
//  SignFlow
//

import SwiftUI

struct OnboardingContainerView: View {
    @EnvironmentObject private var appState: AppState
    @State private var pageIndex = 0

    private let pages = OnboardingPage.pages

    var body: some View {
        ZStack {
            Theme.primaryGradient
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button("Skip") {
                        withAnimation(.spring()) {
                            appState.hasCompletedOnboarding = true
                        }
                    }
                    .font(.system(.body, design: .rounded).weight(.medium))
                    .foregroundStyle(.white.opacity(0.92))

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                TabView(selection: $pageIndex) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        OnboardingPageView(page: page)
                            .tag(index)
                            .padding(.horizontal, 24)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: pageIndex)

                HStack(spacing: 8) {
                    ForEach(0 ..< pages.count, id: \.self) { i in
                        Capsule()
                            .fill(i == pageIndex ? Color.white : Color.white.opacity(0.35))
                            .frame(width: i == pageIndex ? 22 : 8, height: 8)
                            .animation(.spring(response: 0.35), value: pageIndex)
                    }
                }
                .padding(.bottom, 12)

                PrimaryButton(title: pageIndex == pages.count - 1 ? "Get Started" : "Continue") {
                    if pageIndex < pages.count - 1 {
                        withAnimation(.spring()) {
                            pageIndex += 1
                        }
                    } else {
                        withAnimation(.spring()) {
                            appState.hasCompletedOnboarding = true
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 28)
            }
        }
    }
}

private struct OnboardingPageView: View {
    let page: OnboardingPage

    @State private var appeared = false

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 36, style: .continuous)
                    .fill(Color.white.opacity(0.14))
                    .frame(height: 280)
                    .overlay {
                        RoundedRectangle(cornerRadius: 36, style: .continuous)
                            .stroke(Color.white.opacity(0.28), lineWidth: 1)
                    }
                    .shadow(color: .black.opacity(0.12), radius: 24, x: 0, y: 14)

                Image(systemName: page.systemImage)
                    .font(.system(size: 72, weight: .medium))
                    .foregroundStyle(.white)
                    .symbolRenderingMode(.hierarchical)
                    .scaleEffect(appeared ? 1 : 0.85)
                    .opacity(appeared ? 1 : 0)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text(page.title)
                    .font(.system(.title, design: .rounded).weight(.bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(page.subtitle)
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.white.opacity(0.9))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 4)
            .offset(y: appeared ? 0 : 12)
            .opacity(appeared ? 1 : 0)

            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.82).delay(0.05)) {
                appeared = true
            }
        }
        .onDisappear {
            appeared = false
        }
    }
}

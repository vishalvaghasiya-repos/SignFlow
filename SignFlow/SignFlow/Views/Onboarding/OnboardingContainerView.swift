//
//  OnboardingContainerView.swift
//  SignFlow
//

import SwiftUI

struct OnboardingContainerView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    @State private var pageIndex = 0

    private let pages = OnboardingPage.pages

    var body: some View {
        ZStack {
            Theme.primaryGradient
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button {
                        withAnimation(.spring()) {
                            appState.hasCompletedOnboarding = true
                        }
                    } label: {
                        Text("Skip")
                            .font(.system(.body, design: .rounded).weight(.semibold))
                            .foregroundStyle(skipForeground)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background {
                                Capsule()
                                    .fill(skipBackground)
                                    .shadow(color: skipShadowColor, radius: colorScheme == .light ? 6 : 0, x: 0, y: colorScheme == .light ? 3 : 0)
                                    .overlay {
                                        Capsule()
                                            .stroke(skipStroke, lineWidth: 1)
                                    }
                            }
                    }
                    .buttonStyle(.plain)

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
                            .fill(i == pageIndex ? Theme.primaryText : Theme.primaryText.opacity(0.28))
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

    private var skipForeground: Color {
        colorScheme == .light ? Color.primary.opacity(0.9) : Color.white.opacity(0.95)
    }

    private var skipBackground: Color {
        colorScheme == .light
            ? Color(uiColor: .systemGray6)
            : Color.white.opacity(0.16)
    }

    private var skipStroke: Color {
        colorScheme == .light
            ? Color.black.opacity(0.1)
            : Color.white.opacity(0.22)
    }

    private var skipShadowColor: Color {
        Color.black.opacity(0.1)
    }
}

private struct OnboardingPageView: View {
    let page: OnboardingPage

    @Environment(\.colorScheme) private var colorScheme
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 36, style: .continuous)
                    .fill(colorScheme == .dark ? Color.white.opacity(0.14) : Color.primary.opacity(0.06))
                    .frame(height: 280)
                    .overlay {
                        RoundedRectangle(cornerRadius: 36, style: .continuous)
                            .stroke(colorScheme == .dark ? Color.white.opacity(0.28) : Color.primary.opacity(0.12), lineWidth: 1)
                    }
                    .shadow(color: .black.opacity(0.12), radius: 24, x: 0, y: 14)

                Image(systemName: page.systemImage)
                    .font(.system(size: 72, weight: .medium))
                    .foregroundStyle(colorScheme == .dark ? Color.white : Color.primary)
                    .symbolRenderingMode(.hierarchical)
                    .scaleEffect(appeared ? 1 : 0.85)
                    .opacity(appeared ? 1 : 0)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text(page.title)
                    .font(.system(.title, design: .rounded).weight(.bold))
                    .foregroundStyle(Theme.primaryText)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(page.subtitle)
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(Theme.secondaryText)
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

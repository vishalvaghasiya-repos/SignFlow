//
//  SettingsView.swift
//  SignFlow
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var vm = SettingsViewModel()
    @State private var showRestoreAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.primaryGradient
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 14) {
                        settingsCard(title: "Appearance") {
                            HStack {
                                Label("Light", systemImage: "sun.max.fill")
                                    .font(.system(.caption, design: .rounded).weight(.semibold))
                                    .foregroundStyle(Theme.secondaryText)
                                Spacer()
                                Label("Dark", systemImage: "moon.fill")
                                    .font(.system(.caption, design: .rounded).weight(.semibold))
                                    .foregroundStyle(Theme.secondaryText)
                            }
                            .padding(.top, 2)

                            Picker("Theme", selection: Binding(
                                get: { appState.appAppearanceMode },
                                set: { appState.appAppearanceMode = $0 }
                            )) {
                                ForEach(AppState.AppAppearanceMode.allCases) { mode in
                                    Text(mode.title).tag(mode)
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding(.vertical, 6)
                        }

                        settingsCard(title: "Spread the word") {
                            row("Share App", systemImage: "square.and.arrow.up") { vm.shareApp() }
                        }

                        settingsCard(title: "Support") {
                            row("Rate App", systemImage: "star.fill") { vm.rateApp() }
                            row("Privacy Policy", systemImage: "hand.raised.fill") { vm.openPrivacy() }
                            row("Terms of Use", systemImage: "doc.text") { vm.openTerms() }
                            row("Contact Support", systemImage: "envelope.fill") { vm.contactSupport() }
                            row("Restore Purchases", systemImage: "arrow.clockwise.circle") {
                                Task {
                                    await vm.restorePurchases()
                                    showRestoreAlert = true
                                }
                            }
                        }

                        settingsCard(title: "About") {
                            HStack {
                                Text("Version")
                                    .foregroundStyle(Theme.primaryText)
                                Spacer()
                                Text(vm.appVersion)
                                    .foregroundStyle(Theme.secondaryText)
                                    .font(.system(.subheadline, design: .rounded).monospacedDigit())
                            }
                            .padding(.vertical, 6)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.light, for: .navigationBar)
            .alert("Restore Purchases", isPresented: $showRestoreAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(vm.restoreMessage ?? "Done")
            }
        }
    }

    private func settingsCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.uppercased())
                .font(.system(.caption, design: .rounded).weight(.semibold))
                .foregroundStyle(Theme.secondaryText)

            VStack(spacing: 0) {
                content()
            }
            .padding(14)
            .glassCard(cornerRadius: 20)
        }
    }

    private func row(_ title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .frame(width: 26)
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.secondaryText.opacity(0.65))
            }
            .font(.system(.body, design: .rounded).weight(.medium))
            .foregroundStyle(Theme.primaryText)
            .padding(.vertical, 10)
        }
        .buttonStyle(.plain)
    }
}

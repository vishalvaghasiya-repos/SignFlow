//
//  SettingsView.swift
//  SignFlow
//

import SwiftData
import SwiftUI
import AdsManagerKit


struct SettingsView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.modelContext) private var modelContext
    @ObservedObject private var subscription = SubscriptionManager.shared
    @ObservedObject private var cloudSync = CloudSyncStatus.shared
    @StateObject private var vm = SettingsViewModel()
    @State private var showRestoreAlert = false
    @State private var iCloudSyncToggle = false
    @State private var bannerIsLoaded = false
    @State private var bannerHeight: CGFloat = 0
    @State private var activeWebViewItem: WebViewItem? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.primaryGradient
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 14) {
                        settingsCard(title: "Premium") {
                            if subscription.isPremiumActive {
                                VStack(alignment: .leading, spacing: 10) {
                                    Label("Premium active", systemImage: "checkmark.seal.fill")
                                        .font(.system(.body, design: .rounded).weight(.semibold))
                                        .foregroundStyle(Theme.primaryText)
                                    if let summary = subscription.planExpirationSummary {
                                        Text(summary)
                                            .font(.system(.subheadline, design: .rounded))
                                            .foregroundStyle(Theme.secondaryText)
                                    }
                                    ForEach(Array(subscription.planDetailLines.enumerated()), id: \.offset) { _, line in
                                        Text(line)
                                            .font(.system(.caption, design: .rounded))
                                            .foregroundStyle(Theme.secondaryText.opacity(0.95))
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 4)
                            } else {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Unlock unlimited signing and premium benefits.")
                                        .font(.system(.subheadline, design: .rounded))
                                        .foregroundStyle(Theme.secondaryText)
                                        .multilineTextAlignment(.leading)
                                    PrimaryButton(title: "Upgrade", systemImage: "sparkles") {
                                        appState.showPremiumPaywall = true
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }

                        settingsCard(title: "iCloud library") {
                            VStack(alignment: .leading, spacing: 12) {
                                Toggle("Sync library with iCloud", isOn: $iCloudSyncToggle)
                                    .font(.system(.body, design: .rounded).weight(.medium))
                                    .foregroundStyle(Theme.primaryText)
                                    .tint(Theme.accent)
                                    .disabled(vm.iCloudSyncBusy || !vm.iCloudContainerReachable)
                                    .onChange(of: iCloudSyncToggle) { _, newValue in
                                        Task {
                                            await vm.applyICloudLibrarySync(newValue)
                                            iCloudSyncToggle = DocumentPaths.isICloudLibrarySyncEnabled
                                        }
                                    }

                                if !vm.iCloudContainerReachable {
                                    VStack(alignment: .leading, spacing: 6) {
                                        if vm.iCloudUserSignedIn {
                                            Text("This Apple ID is signed into iCloud, but the app still can’t open an iCloud Documents folder. Turn on iCloud Drive under Settings → Apple ID → iCloud, then restart the app. On Simulator, enable iCloud → Cloud Documents for this target and rebuild.")
                                                .font(.system(.caption, design: .rounded))
                                                .foregroundStyle(Theme.secondaryText)
                                        } else {
                                            Text("Sign in to iCloud in Settings, turn on iCloud Drive, then return here. Library files use iCloud Documents, not only your Apple ID sign-in.")
                                                .font(.system(.caption, design: .rounded))
                                                .foregroundStyle(Theme.secondaryText)
                                        }
                                    }
                                } else {
                                    Text("Stores signature images and exported PDFs in your iCloud container. SwiftData also syncs your library metadata when iCloud is available.")
                                        .font(.system(.caption, design: .rounded))
                                        .foregroundStyle(Theme.secondaryText)
                                }

                                if let last = cloudSync.lastCloudActivity {
                                    Text("Last iCloud activity: \(last.formatted(date: .abbreviated, time: .shortened))")
                                        .font(.system(.caption, design: .rounded).weight(.semibold))
                                        .foregroundStyle(Theme.primaryText.opacity(0.9))
                                } else {
                                    Text("Last iCloud activity: —")
                                        .font(.system(.caption, design: .rounded))
                                        .foregroundStyle(Theme.secondaryText)
                                }

                                if cloudSync.pendingSync, DocumentPaths.isICloudLibrarySyncEnabled {
                                    HStack(spacing: 8) {
                                        ProgressView()
                                            .scaleEffect(0.85)
                                        Text("Sync pending…")
                                            .font(.system(.caption, design: .rounded).weight(.semibold))
                                            .foregroundStyle(Theme.secondaryText)
                                    }
                                }

                                PrimaryButton(title: "Sync now", systemImage: "arrow.triangle.2.circlepath") {
                                    try? modelContext.save()
                                    cloudSync.requestSyncNow()
                                    HapticFeedback.light()
                                }
                                .disabled(!DocumentPaths.isICloudLibrarySyncEnabled || vm.iCloudSyncBusy)

                                if vm.iCloudSyncBusy {
                                    ProgressView("Updating library location…")
                                        .font(.system(.caption, design: .rounded))
                                }
                            }
                            .padding(.vertical, 4)
                        }

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
                             row("Privacy Policy", systemImage: "hand.raised.fill") {
                                 activeWebViewItem = WebViewItem(url: AppConstants.URLs.privacy, title: "Privacy Policy")
                             }
                             row("Terms of Use", systemImage: "doc.text") {
                                 activeWebViewItem = WebViewItem(url: AppConstants.URLs.terms, title: "Terms of Use")
                             }
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
            .safeAreaInset(edge: .bottom) {
                BannerAdView(
                    adType: .ADAPTIVE,
                    isLoaded: $bannerIsLoaded,
                    height: $bannerHeight
                )
                .frame(height: bannerHeight)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.light, for: .navigationBar)
            .alert("Restore Purchases", isPresented: $showRestoreAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(vm.restoreMessage ?? "Done")
            }
            .onAppear {
                subscription.refreshPremiumState()
                iCloudSyncToggle = DocumentPaths.isICloudLibrarySyncEnabled
            }
            .alert("iCloud", isPresented: Binding(
                get: { vm.iCloudSyncError != nil },
                set: { if !$0 { vm.iCloudSyncError = nil } }
            )) {
                Button("OK", role: .cancel) { vm.iCloudSyncError = nil }
            } message: {
                Text(vm.iCloudSyncError ?? "")
            }
            .sheet(item: $activeWebViewItem) { item in
                AppWebViewScreen(url: item.url, title: item.title)
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

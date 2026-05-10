//
//  MainShellView.swift
//  SignFlow
//

import SwiftUI

struct MainShellView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(AppState.MainTab.home)

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
                .tag(AppState.MainTab.history)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(AppState.MainTab.settings)
        }
        .tint(Theme.primaryText)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        .sheet(isPresented: $appState.showPremiumPaywall) {
            PremiumView()
        }
        .onAppear {
            SubscriptionManager.shared.refreshPremiumState()
        }
    }
}

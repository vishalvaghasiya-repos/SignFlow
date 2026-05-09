//
//  SettingsViewModel.swift
//  SignFlow
//

import Combine
import Foundation
import StoreKit
import SwiftUI
import UIKit

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var restoreMessage: String?

    var appVersion: String {
        let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let b = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(v) (\(b))"
    }

    func shareApp() {
        let text = "Sign PDFs beautifully with \(AppConstants.appDisplayName)"
        let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(av)
    }

    func rateApp() {
        UIApplication.shared.open(AppConstants.URLs.appStoreReview)
    }

    func openPrivacy() {
        UIApplication.shared.open(AppConstants.URLs.privacy)
    }

    func openTerms() {
        UIApplication.shared.open(AppConstants.URLs.terms)
    }

    func contactSupport() {
        UIApplication.shared.open(AppConstants.URLs.support)
    }

    func restorePurchases() async {
        do {
            try await SubscriptionManager.shared.restore()
            if SubscriptionManager.shared.isPremiumActive {
                restoreMessage = "Purchases restored."
                HapticFeedback.success()
            } else {
                restoreMessage = "No active purchases found."
            }
        } catch {
            restoreMessage = error.localizedDescription
        }
    }

    private func present(_ controller: UIViewController) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = scene.keyWindow?.rootViewController
        else { return }
        root.present(controller, animated: true)
    }
}

private extension UIWindowScene {
    var keyWindow: UIWindow? { windows.first { $0.isKeyWindow } }
}

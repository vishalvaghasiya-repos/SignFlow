//
//  PremiumViewModel.swift
//  SignFlow
//

import Combine
import Foundation
import StoreKit

@MainActor
final class PremiumViewModel: ObservableObject {
    @Published var selectedPeriod: SubscriptionPeriod = .yearly
    @Published var isPurchasing = false
    @Published var statusMessage: String?

    private let subscription = SubscriptionManager.shared

    var productsLoaded: Bool {
        !StoreKitManager.shared.products.isEmpty
    }

    func load() async {
        await subscription.load()
    }

    func purchase() async {
        guard let product = subscription.product(for: selectedPeriod) else {
            statusMessage = "Products unavailable. Configure StoreKit in Xcode."
            return
        }
        isPurchasing = true
        statusMessage = nil
        do {
            try await subscription.purchase(product)
            statusMessage = "Welcome to Premium!"
            HapticFeedback.success()
        } catch {
            statusMessage = error.localizedDescription
        }
        isPurchasing = false
    }

    func restore() async {
        isPurchasing = true
        statusMessage = nil
        do {
            try await subscription.restore()
            if subscription.isPremiumActive {
                statusMessage = "Purchases restored."
                HapticFeedback.success()
            } else {
                statusMessage = "No active subscription found."
            }
        } catch {
            statusMessage = error.localizedDescription
        }
        isPurchasing = false
    }

    func displayRows() -> [SubscriptionProductDisplay] {
        SubscriptionPeriod.allCases.map { period in
            let price = StoreKitManager.shared.displayPrice(for: period) ?? "—"
            return SubscriptionProductDisplay(
                id: period.productId,
                period: period,
                displayPrice: price,
                subtitle: period == .yearly ? "Save more annually" : "Flexible billing"
            )
        }
    }
}

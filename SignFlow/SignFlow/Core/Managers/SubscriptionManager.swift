//
//  SubscriptionManager.swift
//  SignFlow
//

import Combine
import Foundation
import StoreKit

@MainActor
final class SubscriptionManager: ObservableObject {
    static let shared = SubscriptionManager()

    private let store = StoreKitManager.shared
    private var cancellables = Set<AnyCancellable>()

    var isPremiumActive: Bool {
        !store.purchasedProductIDs.isEmpty
    }

    private init() {
        store.$purchasedProductIDs
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    func load() async {
        await store.loadProducts()
        await store.refreshPurchased()
    }

    func purchase(_ product: Product) async throws {
        _ = try await store.purchase(product)
    }

    func restore() async throws {
        try await store.restore()
    }

    func product(for period: SubscriptionPeriod) -> Product? {
        store.products.first { $0.id == period.productId }
    }
}

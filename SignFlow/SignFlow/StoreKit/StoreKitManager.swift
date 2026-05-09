//
//  StoreKitManager.swift
//  SignFlow
//

import Combine
import Foundation
import StoreKit

@MainActor
final class StoreKitManager: ObservableObject {
    static let shared = StoreKitManager()

    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs: Set<String> = []

    private var updatesTask: Task<Void, Never>?

    private init() {
        updatesTask = Task { [weak self] in
            for await result in Transaction.updates {
                guard let self else { return }
                if case let .verified(transaction) = result {
                    await self.handle(transaction: transaction)
                }
            }
        }
        Task { await refreshPurchased() }
    }

    deinit {
        updatesTask?.cancel()
    }

    func loadProducts() async {
        do {
            products = try await Product.products(for: AppConstants.ProductID.all)
        } catch {
            products = []
        }
    }

    func purchase(_ product: Product) async throws -> StoreKit.Transaction? {
        let result = try await product.purchase()
        switch result {
        case let .success(verification):
            if case let .verified(transaction) = verification {
                await handle(transaction: transaction)
                await transaction.finish()
                return transaction
            }
            return nil
        case .userCancelled, .pending:
            return nil
        @unknown default:
            return nil
        }
    }

    func restore() async throws {
        try await AppStore.sync()
        await refreshPurchased()
    }

    func refreshPurchased() async {
        var ids = Set<String>()
        for await result in Transaction.currentEntitlements {
            if case let .verified(transaction) = result,
               transaction.revocationDate == nil,
               AppConstants.ProductID.all.contains(transaction.productID)
            {
                ids.insert(transaction.productID)
            }
        }
        purchasedProductIDs = ids
    }

    private func handle(transaction: StoreKit.Transaction) async {
        if AppConstants.ProductID.all.contains(transaction.productID), transaction.revocationDate == nil {
            purchasedProductIDs.insert(transaction.productID)
        }
    }

    func displayPrice(for period: SubscriptionPeriod) -> String? {
        products.first { $0.id == period.productId }?.displayPrice
    }
}

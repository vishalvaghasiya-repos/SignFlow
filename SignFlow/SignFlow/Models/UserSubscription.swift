//
//  UserSubscription.swift
//  SignFlow
//

import Foundation

enum SubscriptionPeriod: String, CaseIterable, Identifiable {
    case weekly
    case monthly
    case yearly

    var id: String { rawValue }

    var title: String {
        switch self {
        case .weekly: "Weekly"
        case .monthly: "Monthly"
        case .yearly: "Yearly"
        }
    }

    var productId: String {
        switch self {
        case .weekly: AppConstants.ProductID.weekly
        case .monthly: AppConstants.ProductID.monthly
        case .yearly: AppConstants.ProductID.yearly
        }
    }

    var badge: String? {
        switch self {
        case .yearly: "Best value"
        case .monthly: "Popular"
        default: nil
        }
    }
}

struct SubscriptionProductDisplay: Identifiable {
    let id: String
    let period: SubscriptionPeriod
    let displayPrice: String
    let subtitle: String
}

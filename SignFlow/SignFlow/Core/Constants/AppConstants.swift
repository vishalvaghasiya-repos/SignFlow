//
//  AppConstants.swift
//  SignFlow
//

import Foundation

enum AppConstants {
    static let appDisplayName = "E-Sign PDF"

    /// Free-tier cap before upgrade (debug builds use a higher limit for testing).
    static var freeSignLimit: Int {
        #if DEBUG
        50
        #else
        5
        #endif
    }

    /// Must match the entitlement identifier in your RevenueCat dashboard.
    static let defaultRevenueCatEntitlementID = "premium"

    /// Must match **iCloud** capability container in Xcode (and SignFlow.entitlements).
    static let iCloudContainerIdentifier = "iCloud.com.jvapps.signflow"

    enum ProductID {
        static let weekly = "com.signflow.premium.weekly"
        static let monthly = "com.signflow.premium.monthly"
        static let yearly = "com.signflow.premium.yearly"
        static let all: [String] = [weekly, monthly, yearly]
    }

    enum URLs {
        static let privacy = URL(string: "https://example.com/privacy")!
        static let terms = URL(string: "https://example.com/terms")!
        static let support = URL(string: "mailto:support@example.com")!
        static let appStoreReview = URL(string: "https://apps.apple.com/app/id000000000?action=write-review")!
    }
}

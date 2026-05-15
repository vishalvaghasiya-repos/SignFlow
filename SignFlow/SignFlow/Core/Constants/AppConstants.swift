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
        static let weekly = "com.jvapps.signflow.weekly"
        static let monthly = "com.jvapps.signflow.monthly"
        static let yearly = "com.jvapps.signflow.yearly"
        static let all: [String] = [weekly, monthly, yearly]
    }

    enum URLs {
        static let privacy = URL(string: "https://sites.google.com/view/privacypolicycenter/privacy-policy")!
        static let terms = URL(string: "https://sites.google.com/view/privacypolicycenter/terms-conditions")!
        static let support = URL(string: "mailto:vaghasiya907@gmail.com")!
        static let appStoreReview = URL(string: "https://apps.apple.com/app/id6768590632?action=write-review")!
    }
}

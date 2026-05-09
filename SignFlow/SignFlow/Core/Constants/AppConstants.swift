//
//  AppConstants.swift
//  SignFlow
//

import Foundation

enum AppConstants {
    static let appDisplayName = "E-Sign PDF"
    static let freeSignLimit = 5

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

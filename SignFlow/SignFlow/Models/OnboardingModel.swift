//
//  OnboardingModel.swift
//  SignFlow
//

import Foundation

struct OnboardingPage: Identifiable {
    let id = UUID()
    let systemImage: String
    let title: String
    let subtitle: String
}

extension OnboardingPage {
    static let pages: [OnboardingPage] = [
        OnboardingPage(
            systemImage: "doc.badge.plus",
            title: "Sign PDF Documents Easily",
            subtitle: "Upload and sign your important PDF files anytime, anywhere."
        ),
        OnboardingPage(
            systemImage: "signature",
            title: "Manage Your Signatures",
            subtitle: "Create, save, edit, and reuse your signatures instantly."
        ),
        OnboardingPage(
            systemImage: "square.and.arrow.up.on.square",
            title: "Export & Share Securely",
            subtitle: "Preview, download, and share signed documents securely."
        ),
    ]
}

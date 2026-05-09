//
//  AppRouter.swift
//  SignFlow
//

import Foundation

enum AppRoute: Hashable {
    case home
    case history
    case settings
    case pdfSigning(URL)
    case pdfPreview(UUID)
    case signatureEditor(UUID?)
    case premium
}

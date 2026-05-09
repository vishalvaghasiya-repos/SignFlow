//
//  PDFSignaturePlacement.swift
//  SignFlow
//

import CoreGraphics
import Foundation

/// Normalized rect on the page preview (origin top-left, 0...1).
struct PDFSignaturePlacement: Identifiable, Hashable {
    var id: UUID
    var pageIndex: Int
    var normalizedRect: CGRect
    var rotationDegrees: Double

    init(id: UUID = UUID(), pageIndex: Int, normalizedRect: CGRect, rotationDegrees: Double = 0) {
        self.id = id
        self.pageIndex = pageIndex
        self.normalizedRect = normalizedRect
        self.rotationDegrees = rotationDegrees
    }
}

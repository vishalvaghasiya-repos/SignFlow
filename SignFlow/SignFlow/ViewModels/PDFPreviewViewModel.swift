//
//  PDFPreviewViewModel.swift
//  SignFlow
//

import Combine
import Foundation
import PDFKit
import SwiftData
import UIKit

@MainActor
final class PDFPreviewViewModel: ObservableObject {
    @Published var sourceURL: URL
    @Published var document: PDFDocument?
    @Published var currentPageIndex: Int = 0
    @Published var placements: [PDFSignaturePlacement] = []
    @Published var placementRotationByPage: [Int: Double] = [:]
    @Published var selectedSignature: SignatureModel?
    @Published var signatureImage: UIImage?
    @Published var overlayNormalizedRect: CGRect = CGRect(x: 0.2, y: 0.65, width: 0.35, height: 0.12)
    @Published var isSaving = false
    @Published var lastSavedDocument: SignedDocumentModel?
    @Published var errorMessage: String?

    private var modelContext: ModelContext?

    init(url: URL) {
        sourceURL = url
        document = PDFManager.loadDocument(at: url)
    }

    func attach(context: ModelContext) {
        modelContext = context
    }

    var pageCount: Int {
        document?.pageCount ?? 0
    }

    func selectSignature(_ model: SignatureModel) {
        selectedSignature = model
        signatureImage = model.loadImage()
    }

    func resetOverlayPosition() {
        overlayNormalizedRect = CGRect(x: 0.2, y: 0.65, width: 0.35, height: 0.12)
        placementRotationByPage[currentPageIndex] = 0
    }

    func addPlacementFromOverlay() {
        guard signatureImage != nil else { return }
        placements.append(
            PDFSignaturePlacement(
                pageIndex: currentPageIndex,
                normalizedRect: overlayNormalizedRect,
                rotationDegrees: currentRotation
            )
        )
        HapticFeedback.light()
    }

    func removeLatestPlacementOnCurrentPage() {
        guard let index = placements.lastIndex(where: { $0.pageIndex == currentPageIndex }) else { return }
        placements.remove(at: index)
    }

    func clearWorkingSignatureOnCurrentPage() {
        resetOverlayPosition()
        selectedSignature = nil
        signatureImage = nil
    }

    var currentRotation: Double {
        get { placementRotationByPage[currentPageIndex] ?? 0 }
        set { placementRotationByPage[currentPageIndex] = newValue }
    }

    func goToPage(_ index: Int) {
        currentPageIndex = min(max(index, 0), max(pageCount - 1, 0))
        resetOverlayPosition()
    }

    func clearPlacements() {
        placements.removeAll()
    }

    private func effectivePlacements() -> [PDFSignaturePlacement] {
        if placements.isEmpty {
            return [PDFSignaturePlacement(pageIndex: currentPageIndex, normalizedRect: overlayNormalizedRect)]
        }
        return placements
    }

    func saveSignedPDF(
        displayName: String,
        recordUsage: () -> Void
    ) async {
        guard let modelContext, let document, let image = signatureImage else {
            errorMessage = "Missing signature or document."
            return
        }
        isSaving = true
        errorMessage = nil
        defer { isSaving = false }
        do {
            let allPlacements = effectivePlacements()
            let signed = try PDFManager.applySignature(document: document, image: image, placements: allPlacements)
            let saved = try StorageManager.saveSignedDocument(
                context: modelContext,
                displayName: displayName,
                pdfDocument: signed
            )
            lastSavedDocument = saved
            recordUsage()
            HapticFeedback.success()
        } catch {
            errorMessage = error.localizedDescription
            HapticFeedback.warning()
        }
    }
}

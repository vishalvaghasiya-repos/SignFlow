//
//  PersistenceModels.swift
//  SignFlow
//
//  SwiftData models (persistence layer).
//

import Foundation
import SwiftData

@Model
final class SignatureRecord {
    @Attribute(.unique) var id: UUID
    var name: String
    var createdAt: Date
    var imageFileName: String

    init(id: UUID = UUID(), name: String, createdAt: Date = Date(), imageFileName: String) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.imageFileName = imageFileName
    }
}

@Model
final class SignedDocumentRecord {
    @Attribute(.unique) var id: UUID
    var displayName: String
    var relativeFilePath: String
    var createdAt: Date
    var pageCount: Int

    init(
        id: UUID = UUID(),
        displayName: String,
        relativeFilePath: String,
        createdAt: Date = Date(),
        pageCount: Int
    ) {
        self.id = id
        self.displayName = displayName
        self.relativeFilePath = relativeFilePath
        self.createdAt = createdAt
        self.pageCount = pageCount
    }

    var fileURL: URL {
        DocumentPaths.signedPDFDirectory.appendingPathComponent(relativeFilePath)
    }
}

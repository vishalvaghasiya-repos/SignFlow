//
//  FileManager.swift
//  SignFlow
//  Application document paths and file helpers.
//

import Foundation

enum DocumentPaths {
    private static var fm: Foundation.FileManager { .default }

    static var documentsDirectory: URL {
        fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    static var signaturesDirectory: URL {
        let url = documentsDirectory.appendingPathComponent("Signatures", isDirectory: true)
        try? fm.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }

    static var signedPDFDirectory: URL {
        let url = documentsDirectory.appendingPathComponent("SignedPDFs", isDirectory: true)
        try? fm.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }

    static func uniqueFileURL(in directory: URL, extension ext: String) -> URL {
        directory.appendingPathComponent(UUID().uuidString).appendingPathExtension(ext)
    }

    @discardableResult
    static func copyFileToDocuments(from source: URL) throws -> URL {
        let dest = uniqueFileURL(in: documentsDirectory, extension: source.pathExtension)
        if fm.fileExists(atPath: dest.path) {
            try fm.removeItem(at: dest)
        }
        try fm.copyItem(at: source, to: dest)
        return dest
    }

    static func deleteFile(at url: URL) {
        try? fm.removeItem(at: url)
    }
}

//
//  SignFlowApp.swift
//  SignFlow
//
//  E-Sign PDF Documents — entry point.
//

import SwiftData
import SwiftUI

@main
struct SignFlowApp: App {
    @StateObject private var appState = AppState()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SignatureRecord.self,
            SignedDocumentRecord.self,
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("ModelContainer failed: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootCoordinatorView()
                .environmentObject(appState)
        }
        .modelContainer(sharedModelContainer)
    }
}

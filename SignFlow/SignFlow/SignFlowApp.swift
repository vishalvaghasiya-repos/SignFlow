//
//  SignFlowApp.swift
//  SignFlow
//
//  E-Sign PDF Documents — entry point.
//

import SwiftData
import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct SignFlowApp: App {
    @StateObject private var appState = AppState()
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        PurchasesBootstrap.configureIfPossible()
    }

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SignatureRecord.self,
            SignedDocumentRecord.self,
        ])
        let configuration = ModelConfiguration(schema: schema, cloudKitDatabase: .automatic)
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

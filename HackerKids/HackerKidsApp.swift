//
//  HackerKidsApp.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 9/25/24.
//
import GoogleSignIn
import SwiftUI
import SwiftData

@main
struct HackerKidsApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            LocalUser.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .onAppear {
                    GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                        // Check if `user` exists; otherwise, do something with `error`
                    }
                }
        }
        .modelContainer(sharedModelContainer)
    }
}

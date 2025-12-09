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
    @Environment(\.modelContext) private var modelContext
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
    @StateObject private var appState = AppState()
    @StateObject private var audioManager = AudioManager()
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var showSplash = false

    var body: some Scene {
        WindowGroup {
                Group {
                   if showSplash {
                       SplashView()
                           .transition(.opacity) // fade out
                   } else {
                       HomeViewContainer()
                           .transition(.opacity) // fade out
                   }
                }
                .id(localizationManager.currentLanguage)
                .environmentObject(appState)
                .environmentObject(localizationManager)
                .environmentObject(audioManager)
                .preferredColorScheme(.dark)
                .onAppear {
                    // After 4 seconds, switch to HomeContainerView
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation(.easeInOut) {
                            showSplash = false
                        }
                    }
                    #if ISDEBUG
                    print("🐛🐞🐜🦟🪲🪳🕷️ IS DEVELOPMENT TARGET")
                    #else
                    print("✈️✈️✈️✈️✈️✈️✈️ IS RELEASE TARGET")
                    #endif
//                    SessionManager.shared.fetchLastSession(modelContext)
//                    GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
//                        // Check if `user` exists; otherwise, do something with `error`
//                        if let error {
//                            print("GooglePreviousSignIn error: \(error.localizedDescription)")
//                        }
//                        if let user {
//                            userViewModel.successGoogleSignIn(user, modelContext)
//                        }
//                    }
                }
        }
//        .modelContainer(sharedModelContainer)
    }
}

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
    @ObservedObject var userViewModel: LoginViewModel = LoginViewModel()
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

    var body: some Scene {
        WindowGroup {
            StartView(viewModel: userViewModel)
                .preferredColorScheme(.dark)
//                .onAppear {
//                    #if ISDEBUG
//                    print("🐛🐞🐜🦟🪲🪳🕷️ IS DEVELOPMENT TARGET")
//                    #else
//                    print("✈️✈️✈️✈️✈️✈️✈️ IS RELEASE TARGET")
//                    #endif
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
//                }
        }
//        .modelContainer(sharedModelContainer)
    }
}

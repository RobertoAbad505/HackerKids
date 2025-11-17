//
//  HomeViewContainer.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 11/5/25.
//

import MessageUI
import SwiftData
import Foundation
import SwiftUI
import Kingfisher

struct HomeViewContainer: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        NavigationView {
            VStack {
                TabView {
                    StartView()
                        .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                        }
                    PortafolioView()
                        .tabItem {
                            Image(systemName: "circle.grid.3x3.circle")
                            Text("Demos!")
                        }
                    ContactMeView()
                        .tabItem {
                            Image(systemName: "person.circle")
                            Text("contact me")
                        }
                    
                    AboutAppView()
                        .tabItem {
                            Image(systemName: "info.circle")
                            Text("About")
                        }
                }
            }
            .id(appState.localizationManager.currentLanguage)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    HomeViewContainer()
}

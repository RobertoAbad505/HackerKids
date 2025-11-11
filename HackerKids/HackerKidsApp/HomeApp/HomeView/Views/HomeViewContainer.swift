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

    var body: some View {
        NavigationView {
            TabView {
                StartView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                PortafolioView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Demos!")
                    }
                
                AboutAppView()
                    .tabItem {
                        Image(systemName: "info.circle")
                        Text("About")
                    }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    HomeViewContainer()
}

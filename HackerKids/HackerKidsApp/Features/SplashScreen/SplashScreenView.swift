//
//  SplashScreenView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 3/31/25.
//

import SwiftUI

import SwiftUI
import AVKit

struct SplashVideoScreenView: View {
    
    @ObservedObject var viewModel: ChatBTFriendViewModel
    @State private var isChatActive = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Mostrar el video
                VideoPlayer(player: AVPlayer(url: Bundle.main.url(forResource: "intro", withExtension: "mp4")!))
                    .ignoresSafeArea()
                    .onAppear {
                        viewModel.startChat()
                        
                        // Navegar al chat tras 5 segundos o si Bluetooth está listo
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            isChatActive = true
                        }
                    }
                
                // Transición a ChatView
                NavigationLink(
                    destination: ChatWithBTFriendView(),
                    isActive: $isChatActive
                ) {
                    EmptyView()
                }
                .hidden()
            }
        }
    }
}


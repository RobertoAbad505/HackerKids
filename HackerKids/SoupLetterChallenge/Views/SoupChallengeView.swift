//
//  SoupChallengeView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 9/25/24.
//

import SwiftUI

struct SoupChallengeView: View {
    @State private var counter: Int = 0
    @StateObject private var viewModel = SoupGridViewModel()

    var body: some View {
        VStack {
            title
            gameView
            controls
        }
        .onAppear {
            viewModel.startGame()
        }
    }
    var title: some View {
        VStack {
            Text("Sopita challenge")
                .font(.largeTitle)
            Text("by RobertSoft")
                .font(.subheadline)
        }
        .padding()
    }
    var gameView: some View {
        VStack {
            SoupGridView(viewModel: viewModel)
        }
        .padding()
    }
    var controls: some View {
        HStack {
            Button(counter > 0 ? "Nuevo juego!":"Comenzar!") {
                counter += 1
                viewModel.startGame()
            }
            .padding()
        }
    }
}
#Preview {
    SoupChallengeView()
}

//
//  ChallengeWordsListView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 2/1/25.
//

import SwiftUI

struct ChallengeWordsListView: View {
    private let columns = [GridItem(.flexible())] // Una columna con palabras apiladas verticalmente
    @ObservedObject var viewModel: SoupGridViewModel
    init(viewModel: SoupGridViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        ScrollView(.horizontal, content: {
            LazyHGrid(rows: columns) {
                ForEach(viewModel.challengeWords, id: \.self) { word in
                    let found = viewModel.isWordFound(word)
                    ZStack {
                        HStack {
                            Image(systemName: found ? "checkmark.circle":"questionmark.diamond")
                                .foregroundStyle(found ? .white:.black)
                            Text(word)
                                .foregroundStyle(found ? .white:.black)
                                .fixedSize()
                                .font(.headline)
                            Spacer()
                        }
                        .background(
                            ZStack {
                                Spacer()
                            }
                            .edgesIgnoringSafeArea(.all)
                            .background(found ? Color.green : Color.clear)// Marcar palabras encontradas
                            .blur(radius: 20)
                        )
                        .padding(10)
                    }
                    .background(.ultraThinMaterial)
                    .cornerRadius(30)
                }
            }
        })
        .padding(.leading, 10)
    }
}

#Preview {
    ChallengeWordsListView(viewModel: SoupGridViewModel())
}

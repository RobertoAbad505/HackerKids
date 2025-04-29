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
    @State var challengeWords: [String] = []
    init(viewModel: SoupGridViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        ScrollView(.horizontal, content: {
            LazyHGrid(rows: columns) {
                ForEach(viewModel.challengeWords, id: \.self) { word in
                    let found = viewModel.isWordFound(word)
                    HStack {
                        Image(systemName: found ? "checkmark.circle":"questionmark.diamond")
                            .foregroundStyle(.white)
                        Text(word.word)
                            .foregroundStyle(.white)
                            .fixedSize()
                            .font(.headline)
                        Spacer()
                    }
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .background((found ? Color.green : Color.clear).edgesIgnoringSafeArea(.all))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        })
        .padding(.leading, 5)
    }
}
struct WordChallenge: Hashable {
    var word: String
    var found: Bool = false
    init(word: String, found: Bool = false) {
        self.word = word
    }
}

#Preview {
    ChallengeWordsListView(viewModel: SoupGridViewModel())
}

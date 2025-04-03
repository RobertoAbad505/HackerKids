//
//  ChallengeTimerView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 2/1/25.
//

import SwiftUI

struct ChallengeTimerView: View {
    @ObservedObject var viewModel: SoupGridViewModel

    var body: some View {
        // Marcador de tiempo
        HStack(alignment: .center) {
            Text("Tiempo:")
                .font(.headline)
            Text(viewModel.tiempoFormateado)
                .font(.body)
                .monospacedDigit()
            Spacer()
            Text("\(viewModel.foundWords.count)/\(viewModel.challengeWords.count)")
        }
        .fontWeight(.bold)
        .background(Color.clear)
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
    }
}

#Preview {
    ChallengeTimerView(viewModel: SoupGridViewModel())
}

//
//  SoupLetterView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 9/26/24.
//

import SwiftUI

struct SoupLetterView: View {
    @ObservedObject var viewModel: SoupGridViewModel
    let row: Int
    let col: Int
    let soupLetter: String
    init(viewModel: SoupGridViewModel, row: Int, col: Int) {
        self.viewModel = viewModel
        self.row = row
        self.col = col
        self.soupLetter = String(viewModel.grid[row][col])
    }
    var body: some View {
        VStack(alignment: .center, content: {
            Text(soupLetter)
                .foregroundStyle(Color.black)
                .font(.system(size: 20))
                .bold()
                .fixedSize(horizontal: true, vertical: true)
                .padding(.horizontal, soupLetter == "I" ? 5:0)
        })
        .padding(5)
        .background(setColor())// Marcar palabras encontradas
    }
    func setColor() -> Color {
        if viewModel.selectedPositions.contains(GridPosition(row: row, col: col)) {
            return .orange
        } else {
            return viewModel.isCorrectPosition(row: row, col: col) ? Color.green : Color.white
        }
    }
}

#Preview {
    SoupLetterView(viewModel: SoupGridViewModel(), row: 1, col: 1)
}

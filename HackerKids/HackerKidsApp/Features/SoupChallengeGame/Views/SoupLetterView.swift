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
    let isIpad: Bool
    init(viewModel: SoupGridViewModel, row: Int, col: Int, isIpad: Bool) {
        self.viewModel = viewModel
        self.row = row
        self.col = col
        self.soupLetter = String(viewModel.grid[row][col])
        self.isIpad = isIpad
    }
    var body: some View {
        VStack(alignment: .center, content: {
            Text(soupLetter)
                .foregroundStyle(Color.white)
                .font(.system(size: isIpad ? 30 : 20))
                .bold()
                .fixedSize(horizontal: true, vertical: true)
        })
        .padding(8)
        .background(setColor())// Marcar palabras encontradas
        .clipShape(Circle())
    }
    func setColor() -> Color {
        if viewModel.selectedPositions.contains(GridPosition(row: row, col: col)) {
            return .orange
        } else {
            return viewModel.isCorrectPosition(row: row, col: col) ? Color.green : Color.clear
        }
    }
}

#Preview {
    SoupLetterView(viewModel: SoupGridViewModel(), row: 1, col: 1, isIpad: false)
}

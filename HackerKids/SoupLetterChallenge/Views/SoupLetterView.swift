//
//  SoupLetterView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 9/26/24.
//

import SwiftUI

struct SoupLetterView: View {
    @ObservedObject var viewModel: SoupGridViewModel
    let id: String
    let row: Int
    let col: Int
    init(viewModel: SoupGridViewModel, row: Int, col: Int) {
        self.viewModel = viewModel
        self.id = "\(row)-\(col)"
        self.row = row
        self.col = col
    }
    var body: some View {
        HStack {
            Button(action: {
                // Agregar la letra seleccionada a la lista temporal
                viewModel.selectedPositions.append(GridPosition(row: row, col: col))
                
                // Si la dirección de selección está completa, validar
                if viewModel.selectedPositions.count >= 2 {
                    viewModel.validateSelection()
                }
                // Handle letter selection here if needed
                print("Selected: \(viewModel.grid[row][col])")
            }, label: {
                Text(String(viewModel.grid[row][col]))
                    .foregroundStyle(Color.black)
                    .font(.system(size: 24))                
            })
            .id(id)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(setColor())
        .cornerRadius(5)
    }
    func setColor() -> Color {
        if viewModel.selectedPositions.contains(GridPosition(row: row, col: col)) {
            return .orange
        } else {
            return viewModel.isCorrectPosition(row: row, col: col) ? Color.green : Color.blue.opacity(0.3)
        }
    }
}

#Preview {
    SoupLetterView(viewModel: SoupGridViewModel(), row: 1, col: 1)
}

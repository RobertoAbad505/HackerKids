//
//  SoupGridView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 9/25/24.
//

import SwiftUI

struct SoupGridView: View {
    @ObservedObject var viewModel: SoupGridViewModel // Use @ObservedObject to watch for changes in the ViewModel

    var body: some View {
        VStack {
            if !viewModel.grid.isEmpty &&
                viewModel.grid.count == viewModel.gridSize &&
                viewModel.grid.allSatisfy({ $0.count == viewModel.gridSize }) {
                gridBody
                wordsListView
            } else {
                loadingGridBody
            }
        }
    }
    var gridBody: some View {
        let columns = Array(repeating: GridItem(.flexible()), count: viewModel.gridSize)
        return LazyVGrid(columns: columns, spacing: 5) {
            ForEach(0..<viewModel.gridSize, id: \.self) { row in
                ForEach(0..<viewModel.gridSize, id: \.self) { col in
                    SoupLetterView(viewModel: viewModel, row: row, col: col)                        
                }
            }
        }
    }
    // Grid de palabras que deben ser encontradas
    var wordsListView: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())] // Una columna con palabras apiladas verticalmente
        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(viewModel.challengeWords, id: \.self) { word in
                HStack {
                    Image(systemName: "character.magnify")
                    Text(word)
                        .font(.footnote)
                }
                .padding()
                .background(viewModel.isWordFound(word) ? Color.green : Color.white.opacity(0.3)) // Marcar palabras encontradas
                .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(UIColor.lightGray.toColor().opacity(0.3))
        .border(UIColor.lightGray.toColor().opacity(0.8))
        .cornerRadius(8)
        .padding(.top, 20)
    }
    var loadingGridBody: some View {
        return VStack {
            Text("Cargando...")
                .padding()
        }
    }
}
extension UIColor {
    // Convierte UIColor a Color
    func toColor() -> Color {
        return Color(self)
    }
}
//#Preview {
//    SoupGridView(viewModel: SoupGridViewModel())
//}

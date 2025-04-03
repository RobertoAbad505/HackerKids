//
//  SoupGridView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 9/25/24.
//

import SwiftUI

struct SoupGridView: View {
    @ObservedObject var viewModel: SoupGridViewModel

    var body: some View {
        VStack {
            if !viewModel.grid.isEmpty &&
                viewModel.grid.count == viewModel.gridSize &&
                viewModel.grid.allSatisfy({ $0.count == viewModel.gridSize }) {
                gridBody
            } else {
                loadingGridBody
            }
        }
        .padding(.horizontal)
        .onAppear(perform: viewModel.iniciarTimer)
        .onDisappear(perform: viewModel.detenerTimer)
    }
    var gridBody: some View {
        let columns = Array(repeating: GridItem(.flexible()), count: viewModel.gridSize)
        return VStack {
            VStack {
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(0..<viewModel.gridSize, id: \.self) { row in
                        ForEach(0..<viewModel.gridSize, id: \.self) { col in
                            Button(action: {
                                // Agregar la letra seleccionada a la lista temporal
                                viewModel.selectedPositions.append(GridPosition(row: row, col: col))
                                
                                // Si la dirección de selección está completa, validar
                                if viewModel.selectedPositions.count >= 2 {
                                    viewModel.validateSelection()
                                }
                            }, label: {
                                SoupLetterView(viewModel: viewModel, row: row, col: col)
                            })
                            .id("\(row)-\(col)")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipShape(Circle())
                        }
                    }
                }
                .padding(5)
                .cornerRadius(15)
            }
            .background(Color.white)
            .padding(.top)
            ChallengeTimerView(viewModel: self.viewModel)
        }
        .background(.ultraThinMaterial)
        .cornerRadius(15)
    }
    var loadingGridBody: some View {
        return VStack {
            ProgressView(label: {
                Text("Cargando...")
                    .padding()
            })
        }
    }
}

//
//  SoupChallengeWin.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/29/25.
//

import SwiftUI

struct SoupChallengeWin: View {
    @StateObject var viewModel: SoupGridViewModel
    @Environment(\.presentationMode) private var presentationMode
    let onEndGame: () -> Void

    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("✅   You won!!  🏆")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                // Marcador de tiempo
                HStack {
                    Spacer()
                    Text("⏱️   Your time:")
                        .font(.headline)
                    Text(viewModel.tiempoFormateado)
                        .font(.title)
                        .monospacedDigit()
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(10)
                controls
            }
            .padding()
            .overlay{
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 4)
            }
            Spacer()
        }
        .padding()
        .foregroundStyle(.white)
        .background(Color.green)
    }
    var controls: some View {
        VStack {
            HStack(alignment: .center, spacing: 30) {
                Button(action: {
                    onEndGame()
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    HStack {
                        Image(systemName: "clear")
                            .foregroundColor(.white)
                            .frame(width: 25, height: 27)
                        Text("Exit game!")
                            .font(.headline)
                    }
                })
                .foregroundStyle(Color.white)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                Button(action: {
                    viewModel.counter += 1
                    viewModel.startGame()
                }, label: {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .frame(width: 20, height: 25)
                        Text(viewModel.counter > 0 ? "New game!":"Reset!")
                            .font(.headline)
                    }
                })
                .foregroundStyle(Color.white)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
            }
            .padding()
            .overlay{
                if viewModel.win {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 4)
                }
            }
            .padding(.top)
        }
    }
}

#Preview {
    SoupChallengeWin(viewModel: .init(), onEndGame: {})
}

//
//  SoupChallengeView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 9/25/24.
//

import SwiftUI

struct SoupChallengeView: View {
    @Environment(\.presentationMode) private var presentationMode
    let onExit: () -> Void
    @StateObject private var viewModel = SoupGridViewModel()
    @State private var showExitConfirmation = false
    var challenge: ChallengeModel?
    
    
    init(onExit: @escaping (() -> Void), challenge: ChallengeModel? = nil) {
        self.onExit = onExit
        self.challenge = challenge
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Spacer()
                    title
                    gameView
                    wordsListView
                    controls
                    Spacer()
                }
                .background(
                    ZStack {
                        Spacer()
                    }
                    .background(Color.clear.blur(radius: 20))
                    .edgesIgnoringSafeArea(.all)
                )
                .frame(maxWidth: .infinity, alignment: .init(horizontal: .center, vertical: .top))
            }
        }
        .navigationBarBackButtonHidden()
        .background(Image("universe_background")
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.addChallenge(challenge: challenge)
        }
        .popover(isPresented: $viewModel.win) {
            VStack {
                Text("")
                Text("You won!")
                // Marcador de tiempo
                HStack {
                    Text("Tiempo:")
                        .font(.headline)
                    Text(viewModel.tiempoFormateado)
                        .font(.body)
                        .monospacedDigit()
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                controls
            }
        }
        .alert("¿Deseas salir del juego?", isPresented: $showExitConfirmation) {
            Button("Cancelar", role: .cancel) {}
            Button("Salir", role: .destructive, action: {
                self.presentationMode.wrappedValue.dismiss()
                onExit()
            })
        }
    }
    var title: some View {
        VStack {
            HStack(spacing: 30) {
                Button(action: {
                    showExitConfirmation.toggle()
                }, label: {
                    Image(systemName: "chevron.compact.backward")
                        .resizable()
                        .frame(width: 14, height: 24)
                        .foregroundStyle(Color.black)
                })
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 25, height: 25)
                VStack {
                    Text("Player 1 turn")
                        .font(.title)
                }
                Spacer()
            }
            .padding()
        }
        .background(.ultraThinMaterial)
        .edgesIgnoringSafeArea(.top)
    }
    var gameView: some View {
        SoupGridView(viewModel: viewModel)
    }
    var controls: some View {
        VStack {
            HStack {
                Button(action: {
                    viewModel.counter += 1
                    viewModel.startGame()
                }, label: {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .frame(width: 20, height: 25)
                        Text(viewModel.counter > 0 ? "Nuevo juego!":"Reset turn")
                    }
                })
                .foregroundStyle(Color.black)
                .padding(.horizontal)
                .padding(.vertical, 7)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
            }
        }
    }
    // Grid de palabras que deben ser encontradas
    var wordsListView: some View {
        ChallengeWordsListView(viewModel: viewModel)
    }
}

#Preview {
    SoupChallengeView(onExit: {})
}

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
    @State private var playerName: String = ""
    @State private var register = false
    var challenge: ChallengeModel?
    
    
    init(onExit: @escaping (() -> Void), _ challenge: ChallengeModel? = nil) {
        self.onExit = onExit
        self.challenge = challenge
    }

    var body: some View {
        VStack {
            if !register {
                registerNewPlayer
            } else {
                startedGame
            }
        }
        .navigationBarBackButtonHidden()
        .background(Image("soupBackground").resizable().ignoresSafeArea())
        .onAppear {
            viewModel.addChallenge(challenge: challenge)
        }
        .popover(isPresented: $viewModel.win) {
            SoupChallengeWin(viewModel: self.viewModel, onEndGame: {
                self.presentationMode.wrappedValue.dismiss()
            })
        }
        .alert(LocalizedStringKey("exitConfirmationTitle"), isPresented: $showExitConfirmation) {
            Button("❌Cancelar", role: .cancel) {}
            Button("✅Salir", role: .destructive, action: {
                self.presentationMode.wrappedValue.dismiss()
                onExit()
            })
        }
    }
    var registerNewPlayer: some View {
        VStack {
            HStack {
                Button(action: {
                    showExitConfirmation.toggle()
                }, label: {
                    Image(systemName: "chevron.compact.backward")
                        .resizable()
                        .frame(width: 20, height: 25)
                        .foregroundStyle(Color.white)
                })
                Spacer()
            }
            .padding(.leading)
            Spacer()
            VStack(alignment: .center, spacing: 25) {
                Text("Who is player 1?")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .fontWeight(.black)
                TextField("Enter your name . . .", text: $playerName, onCommit: {
                    withAnimation {
                        self.register = true
                    }
                })
                .autocorrectionDisabled()
                .keyboardType(.alphabet)
                .font(.title)
                .padding()
                .background(.blue.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke((.white), lineWidth: 3)
                }
                Button(action: {
                    withAnimation {
                        self.register = true
                    }
                }, label: {
                    HStack {
                        Spacer()
                        Text("✅ Start!")
                            .font(.title)
                            .fontWeight(.bold)
                            .fontDesign(.monospaced)
                            .foregroundStyle(.white) // Color dinámico
                        Spacer()
                    }
                    .padding()
                    .background(Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke((.white), lineWidth: 3)
                    )
                })
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal)
            Spacer()
        }
    }
    var startedGame: some View {
        VStack {
            ScrollView {
                VStack(alignment: .center, spacing: 15) {
                    title
                    gameView
                    wordsListView
                    controls
                }
                .padding(.vertical)
            }
        }
    }
    var title: some View {
        HStack {
            Button(action: {
                showExitConfirmation.toggle()
            }, label: {
                Image(systemName: "chevron.compact.backward")
                    .resizable()
                    .frame(width: 18, height: 25)
                    .foregroundStyle(Color.white)
            })
            .padding(.leading)
            .padding(.vertical, 5)
            Spacer()
            VStack {
                Text("👾 \(playerName)")
                    .font(.title)
                    .fontWeight(.bold)
            }
            Spacer()
        }
        .padding(5)
        .background(.ultraThinMaterial)
        .padding(.bottom, 5)
    }
    var gameView: some View {
        SoupGridView(viewModel: viewModel)
    }
    var controls: some View {
        VStack {
            HStack(alignment: .center, spacing: 20) {
                Button(action: {
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
            .padding(5)
            .overlay{
                if viewModel.win {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 4)
                }
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

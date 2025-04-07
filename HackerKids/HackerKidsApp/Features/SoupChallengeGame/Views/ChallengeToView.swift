//
//  ChallengeToView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 12/14/24.
//

import SwiftUI

struct ChallengeToView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var challengeToViewModel: ChallengeToViewModel = ChallengeToViewModel()
    @State var newWord: String = ""
    let onExit: () -> Void
    @State private var showToast = false
    @State private var toastMessage: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 50) {
                title
                challengerName
                selectDifficulty
                addWords
                Spacer()
                startChallengeButton
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .overlay(
                Text("Este es un mensaje breve")
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .opacity(showToast ? 1 : 0)
                    .animation(.easeInOut, value: showToast)
            )
        }
    }
    var title: some View {
        Text("Challenge your friends!")
            .font(.title)
    }
    var challengerName: some View {
        VStack {
            Text("Type challengers name")
                .font(.subheadline)
            HStack {
                Image(systemName: "person.circle.fill")
                TextField("Challenger", text: $challengeToViewModel.challenge.challengerName)
            }
            .font(.body)
        }
    }
    var addWords: some View {
        VStack {
            Text("Type your words here")
                .font(.subheadline)
            HStack {
                TextField("New Word", text: $newWord)
                    .font(.body)
                    .foregroundColor(Color.blue)
                    .keyboardType(.alphabet)
                    .disableAutocorrection(true)
                Button(action: {
                    if newWord.isEmpty {
                        toastMessage = "Please enter a word!"
                        return
                    }
                    if challengeToViewModel.challenge.challengeWords.contains(newWord) {
                        newWord = ""
                        toastMessage = "Word already added!"
                        return
                    }
                    challengeToViewModel.challenge.challengeWords.append(newWord)
                    newWord = ""
                }, label: {
                    Image(systemName: "plus")
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                })
            }
            ForEach(challengeToViewModel.challenge.challengeWords, id: \.self) { word in
                Text(word)
            }
        }
    }
    var selectDifficulty: some View {
        VStack {
            HStack {
                Text("Select difficulty")
                    .font(.subheadline)
            }
            Picker("Select difficulty", selection: $challengeToViewModel.challenge.diffuculty, content: {
                ForEach(DifficultyLevel.allCases) { difficulty in
                                    Text(difficulty.rawValue).tag(difficulty)
                }
            })
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    var startChallengeButton: some View {
        withAnimation(.easeInOut(duration: 0.2)) {
            NavigationLink(destination: SoupChallengeView(onExit: {
                self.presentationMode.wrappedValue.dismiss()
            }, challenge: challengeToViewModel.challenge), label: {
                HomeButtonView(title: "Start vs challenge!", icon: "play")
            })
            .padding(.bottom, 30)
        }
    }
}

#Preview {
    ChallengeToView(onExit: {})
}

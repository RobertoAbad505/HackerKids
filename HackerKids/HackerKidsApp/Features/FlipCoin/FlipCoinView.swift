//
//  FlipCoinView.swift
//  FlipMyLuckApp
//
//  Created by Roberto Ramirez on 9/3/25.
//

import SwiftUI

struct FlipCoinView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var audioManager: AudioManager
    @State private var isFlipping = false
    @State private var rotation: Double = 0
    @State private var result: Bool? = nil // true = cara, false = cruz
    let duration: Double = 3 // duración total del giro
    
    //Style
    @State var colorAccent = Color.white
    
    //DATA
    @State private var results: [Bool] = []
    @State private var gameType: GameType = .oneOfOne
    @State private var showWiner: Bool = false
    @State private var winer: Bool = false
    @State private var throwingCoing: Bool = false


    var body: some View {
        ScrollView  {
            contentView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .meshAnimatedBackgroundSimple()
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing, content: {
                Menu {
                    Menu("Rounds") {
                        Button("1 of 1", action: { changeGameType(.oneOfOne) })
                        Button("2 out of 3", action: { changeGameType(.twoOutOfThree) })
                               Button("Free throws", action: { changeGameType(.freeForAll) })
                    }
                    Button("Reset", action: {
                        self.results.removeAll()
                        self.winer = false
                        self.showWiner = false
                    })
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(colorScheme != .dark ? .black : .white))
                }.mapStyle(.imagery)
            })
        })
        .navigationTitle("Flip my luck!🪙")
        .overlay {
            if showWiner {
                VStack {
                    roundWinView
                }
                .background(.clear)
                .edgesIgnoringSafeArea(.all)
                .background(.ultraThinMaterial)
            }
        }
    }
    var contentView: some View {
        VStack(alignment: .center, spacing: 30) {
            CoinFlipView(results: $results, onCoinLand: { _ in
                showResults()
            })
            .background(.clear)
            if self.gameType != .oneOfOne {
                resultsView
            }
            Spacer()
            gameTypeView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 120)
        .padding(.top, self.gameType == .oneOfOne ? 100:0)
        .padding(.horizontal, 30)
        .padding(.bottom, 20)
    }
    var gameTypeView: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Game type")
            Picker(selection: $gameType, label: Text("")) {
                ForEach(GameType.allCases, id: \.self) { gametype in
                    Text(getTabName(gametype))
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: gameType) { newValue in
                changeGameType(newValue)
                print("game reset! -> \(newValue)")
            }
        }
        .padding(.bottom, 30)
    }
    func getTabName(_ gametype: GameType) -> String {
        switch gametype {
        case .oneOfOne:
            return "1/1"
        case .twoOutOfThree:
            return "2/3"
        case .freeForAll:
            return "Free for all"
        }
    }
    var roundWinView: some View {
        VStack(alignment: .center, spacing: 25) {
            Spacer()
            Text("You win!")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
            VStack {
                if winer {
                    headsImage
                        .frame(maxWidth: 250, maxHeight: 250)
                } else {
                    tailsImage
                        .frame(maxWidth: 250, maxHeight: 250)
                }
            }
            if self.gameType != .oneOfOne {
                scoreBoardView
            }
            Button(action: {
                showWiner.toggle()
                resetGame()
            }, label: {
                HStack {
                    Spacer()
                    Text("⟲")
                        .font(.system(size: 45, design: .rounded))
                    Text(" Try again!")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                    Spacer()
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke((colorAccent), lineWidth: 3)
                )
            })
            .padding(25)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(edges: .all)
        .background(.clear)
    }
    func changeGameType(_ selection: GameType){
        self.gameType = selection
        resetGame()
    }
    var resultsView: some View {
        // Historial
        VStack(alignment: .center, spacing: 5) {
            HStack {
                Spacer()
                Text(self.gameType.rawValue)
                    .font(.headline)
                    .padding()
                Spacer()
            }
            scoreBoardView
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke((colorAccent), lineWidth: 3)
        )
    }
    var scoreBoardView: some View {
        VStack(alignment: .center) {
            switch self.gameType {
            case .oneOfOne:
                EmptyView()
            case .twoOutOfThree, .freeForAll:
                markerView
            }
        }
    }
    var flipsList: some View {
        VStack {
            if results.count > 0 {
                markerView
            }
            ForEach(Array(results.indices.reversed()), id: \.self) { index in
                HStack {
                    Image(results[index] ? "headsImg" : "tailsImg")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                    Text("\(index + 1)#: \(results[index] ? "Cara" : "Cruz")").padding(.trailing)
                    Spacer()
                }
                .font(.headline.bold())
                .foregroundColor(results[index] ? .yellow : .blue)
                .background(results[index] ? Color.gray.opacity(0.5) : Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke((colorAccent), lineWidth: 2)
                )
            }
        }
    }
    var markerView: some View {
        HStack(alignment: .center) {
            Spacer()
            VStack {
                tailsImage
                    .frame(maxWidth: 75, maxHeight: 75)
                Text("\(results.filter({ $0 == false }).count)")
                    .font(.title3)
            }
            VStack {
                headsImage
                    .frame(maxWidth: 75, maxHeight: 75)
                Text("\(results.filter({ $0 == true }).count)")
                    .font(.title3)
            }
            Spacer()
        }
    }
    var headsImage: some View {
        Image("headsImg")
            .resizable()
            .scaledToFit()
            .rotation3DEffect(
                .degrees(rotation),
                axis: (x: 0, y: 1, z: 0)
            )
    }
    var tailsImage: some View {
        Image("tailsImg")
            .resizable()
            .scaledToFit()
            .rotation3DEffect(
                .degrees(180),
                axis: (x: 0, y: 1, z: 0)
            )
    }

    func showResults() {
        let _ = getWinner()
        switch self.gameType {
            case .oneOfOne:
            if results.count == 1 {
                self.showWiner = true
            }
        case .twoOutOfThree:
            if results.count == 2 && results[0] == results [1] {
                self.showWiner = true
//                self.resetGame()
            }
            if results.count == 3 {
                self.showWiner = true
//                self.resetGame()
            }
        default:
            return
        }
    }
    func getWinner() {
        let newWiner: Bool? = results.filter(\.self).first
        print("SCORE - \(self.gameType.rawValue):")
        print(results)
        print("Winner: \((newWiner ?? false) ? "Heads" : "Tails")\n-----------------")
        self.winer = newWiner ?? false
    }
    enum GameType: String, CaseIterable {
        case oneOfOne = "One Out Of One"
        case twoOutOfThree = "Two Out Of Three"
        case freeForAll = "Free For All"
    }
    func resetGame() {
        results.removeAll()
        print("Game Reseted \n-----------------")
    }
}

#Preview {
    FlipCoinView()
}

//
//  FlipCoinView.swift
//  FlipMyLuckApp
//
//  Created by Roberto Ramirez on 9/3/25.
//

import SwiftUI

import SwiftUI

struct FlipCoinView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var audioManager: AudioManager
    @State private var isFlipping = false
    @State private var rotation: Double = 0
    @State private var result: Bool? = nil // true = cara, false = cruz
    let duration: Double = 2.5 // duración total del giro
    
    //Style
    @State var colorAccent = Color.yellow
    
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
        .background(.black)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing, content: {
                Menu {
                    Menu("Rounds") {
                        Button("1 of 1", action: { changeGameType(.oneOfOne) })
                        Button("2 out of 3", action: { changeGameType(.twoOutOfThree) })
                               Button("Free throws", action: { changeGameType(.freeForAll) })
                    }
                } label: {
                    //gear icon
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(colorScheme != .dark ? .black : .white))
                }.mapStyle(.imagery)
            })
        })
        .sheet(isPresented: $showWiner, content: {
            roundWinView
        })
    }
    var contentView: some View {
        VStack(alignment: .center, spacing: 30) {
            coinView
            triggerView
            if self.gameType != .oneOfOne {
                resultsView
            }
        }
        .padding(.top, 50)
        .padding(.top, self.gameType == .oneOfOne ? 150:0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 30)
        .navigationTitle("Flip my luck!🪙")
    }
    var roundWinView: some View {
        VStack(alignment: .center, spacing: 30) {
            Spacer()
            Text("You win!")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
            if winer {
                headsImage
                    .frame(maxWidth: 250, maxHeight: 250)
            } else {
                tailsImage
                    .frame(maxWidth: 250, maxHeight: 250)
            }
            Button(action: {
                showWiner.toggle()
            }, label: {
                HStack {
                    Text("⟲")
                        .font(.system(size: 30, design: .rounded))
                    Text(" Try again!")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                }
            })
            .padding(.horizontal, 50)
            .background(colorAccent)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(edges: .all)
        .background(.black)
    }
    func changeGameType(_ selection: GameType){
        self.gameType = selection
        resetGame()
    }
    
    var coinView: some View {
        ZStack {
            // Cara (se ve cuando el ángulo es < 90° o > 270°)
            Image("headsImg")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .opacity(showingFront ? 1 : 0)
            
            // Cruz (se ve cuando el ángulo es entre 90° y 270°)
            Image("tailsImg")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .opacity(showingFront ? 0 : 1)
        }
        .padding()
        .frame(width: 250, height: 250)
        .clipShape(Circle())
        .rotation3DEffect(
            .degrees(rotation),
            axis: (x: 0, y: 1, z: 0)
        )
    }
    
    var triggerView: some View {
        HStack {
            Spacer()
            if !throwingCoing {
                withAnimation {
                    Button(action: flipCoin) {
                        Text("🪙 Lanzar moneda!")
                            .font(.headline)
                            .padding(.vertical, 10)
                            .foregroundColor(.white)
                    }
                }
            }
            Spacer()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke((colorAccent), lineWidth: 3)
        )
        .padding(.horizontal, 30)
    }
    var resultsView: some View {
        // Historial
        VStack(alignment: .leading) {
            if results.count == 0 {
                 Spacer()
            }
            HStack {
                Spacer()
                Text(self.gameType.rawValue)
                Spacer()
            }
            .font(.title3)
            .padding()
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
            case .twoOutOfThree:
                HStack(alignment: .center) {
                    Spacer()
                    VStack {
                        tailsImage
                            .frame(maxWidth: 75, maxHeight: 75)
                        Text("\(results.filter({ $0 == false }).count)")
                            .font(.largeTitle)
                    }
                    VStack {
                        headsImage
                            .frame(maxWidth: 75, maxHeight: 75)
                        Text("\(results.filter({ $0 == true }).count)")
                            .font(.largeTitle)
                    }
                    Spacer()
                }
            case .freeForAll:
                ForEach(Array(results.indices.reversed()), id: \.self) { index in
                    HStack {
                        Image(results[index] ? "headsImg" : "tailsImg")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 75)
                        Text("Tiro \(index + 1): \(results[index] ? "Cara" : "Cruz")").padding(.trailing)
                        Spacer()
                    }
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .foregroundColor(results[index] ? .yellow : .blue)
                    .padding(5)
                    .background(results[index] ? Color.gray : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke((colorAccent), lineWidth: 2)
                    )
                }
            }
        }
    }
    var headsImage: some View {
        Image("headsImg")
            .resizable()
            .scaledToFit()
    }
    var tailsImage: some View {
        Image("tailsImg")
            .resizable()
            .scaledToFit()
    }
    
    private var showingFront: Bool {
        let normalized = rotation.truncatingRemainder(dividingBy: 360)
        return normalized < 90 || normalized > 270
    }
    
    private func flipCoin() {
        self.throwingCoing = true
        audioManager.playSoundEffect(named: "coinFx")
        guard !isFlipping else { return }
        isFlipping = true
        result = nil
        
        let finalResult = Bool.random()
        
        // Si es true → debe acabar en 0°, si es false → en 180°
        let target = finalResult ? 0 : 180
        
        // Vueltas completas extras (entre 2 y 4 para variar)
        let extraSpins = Int.random(in: 2...4) * 360
        
        // Ángulo final garantizado
        let endRotation = Double(extraSpins + target)
        
        withAnimation(.easeOut(duration: duration)) {
            rotation += endRotation
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            // Normalizamos para evitar acumulación
            rotation = Double(target)
            result = finalResult
            isFlipping = false
            results.append(finalResult)
            showResults()
            self.throwingCoing = false
        }
    }
    func showResults() {
        let _ = getWinner()
        switch self.gameType {
            case .oneOfOne:
            if results.count == 1 {
                self.showWiner = true
                self.resetGame()
            }
        case .twoOutOfThree:
            if results.count == 2 && results[0] == results [1] {
                
                self.showWiner = true
                self.resetGame()
            }
            if results.count == 3 {
                self.showWiner = true
                self.resetGame()
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
    enum GameType: String {
        case oneOfOne = "One Out Of One"
        case twoOutOfThree = "Two Out Of Three"
        case freeForAll = "Free For All"
    }
    func resetGame() {
        results.removeAll()
    }
}

#Preview {
    FlipCoinView()
}

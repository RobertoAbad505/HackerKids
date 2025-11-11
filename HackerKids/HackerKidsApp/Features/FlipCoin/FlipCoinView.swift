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
//    @EnvironmentObject var audioManager: AudioManager
    @State private var isFlipping = false
    @State private var rotation: Double = 0
    @State private var result: Bool? = nil // true = cara, false = cruz
    let duration: Double = 2.5 // duración total del giro
    
    //Style
    @State var colorAccent = Color.yellow
    
    //DATA
    @State private var results: [Bool] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 45) {
                Spacer()
                coinView
                triggerView
                resultsView
                Spacer()
            }
        }
        .background(.black)
        .padding()
        .navigationTitle("Flip my luck!🪙")
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing, content: {
                Menu {
                    Menu("Rounds") {
                        Button("1 of 1", action: {})
                        Button("2 out of 3", action: {})
                        Button("Free throws", action: {})
                    }
                } label: {
                    //gear icon
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(colorScheme != .dark ? .black : .white))
                }
            })
        })
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
//        .background(showingFront ? .gray:.black)
        .clipShape(Circle())
        .rotation3DEffect(
            .degrees(rotation),
            axis: (x: 0, y: 1, z: 0)
        )
    }
    
    var triggerView: some View {
        HStack {
            Spacer()
            Button(action: flipCoin) {
                Text("🪙 Lanzar moneda!")
                    .font(.headline)
                    .padding()
//                    .background(colorAccent)
                    .foregroundColor(.white)
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke((colorAccent), lineWidth: 2)
            )
            Spacer()
        }
    }
    var resultsView: some View {
        // Historial
        VStack {
            if results.count > 0 {
                Text("Results")
                    .font(.title3)
            }
            ForEach(Array(results.indices.reversed()), id: \.self) { index in
                HStack {
                    Image(results[index] ? "headsImg" : "tailsImg")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                    Text("Tiro \(index + 1): \(results[index] ? "Cara" : "Cruz")").padding(.trailing)
                    Spacer()
                }
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .foregroundColor(results[index] ? .yellow : .blue)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke((colorAccent), lineWidth: 2)
                )
            }
        }
    }
    
    private var showingFront: Bool {
        let normalized = rotation.truncatingRemainder(dividingBy: 360)
        return normalized < 90 || normalized > 270
    }
    
    private func flipCoin() {
//        audioManager.playSoundEffect(named: "coinFx")
        
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
        }
    }
}

#Preview {
    FlipCoinView()
}

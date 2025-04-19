//
//  PokemonDetailView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/11/25.
//

import SwiftUI

struct PokemonDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    var index: Int = 0
    @ObservedObject var viewModel: PokemonApiViewModel
    var gradient: LinearGradient {
     return LinearGradient(stops: [
        Gradient.Stop(color: .pink, location: 0.20),
        Gradient.Stop(color: .pink.opacity(0.7), location: 0.30),
        Gradient.Stop(color: .purple, location: 0.50),
    ], startPoint: .top, endPoint: .bottom)
    }
    let range: ClosedRange<Double>
    var columns: [GridItem] {
        return Array(repeating: GridItem(.flexible()), count: 3)
    }
    var attakColumns: [GridItem] {
        return [GridItem(.flexible()), GridItem(.flexible())]
    }
    
    init(viewModel: PokemonApiViewModel) {
        self.viewModel = viewModel
        range = 0...100
    }
    var body: some View {
        VStack {
            ScrollView {
                imageTopHeader
                descriptionView
                pokemonStats
                pokemonMoves
            }
            .edgesIgnoringSafeArea(.top)
        }
        .foregroundStyle(getReverseThemeForeground())
        .fontDesign(.monospaced)
    }
    var imageTopHeader: some View {
        ZStack {
            gradient
            AsyncImage(url: viewModel.selectedPokemon.calcImageUrl()) { image in
                image.resizable()
            } placeholder: {
                Image(systemName: "person.fill.questionmark")
            }
            .frame(width: 200, height: 200)
            .padding(.top, 70)
            .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
    var descriptionView: some View {
        VStack(spacing: 15) {
            Text((viewModel.selectedPokemon.pokemon.name ?? "").capitalizingFirstLetter())
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom)
            HStack(alignment: .top) {
                VStack(alignment: .center) {
                    Text("Height")
                    Text("\(viewModel.selectedPokemon.pokedexDetail?.height ?? 0)\"")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                Spacer()
                VStack {
                    Text("Weight")
                    Text("\(viewModel.selectedPokemon.pokedexDetail?.weight ?? 0) lbs")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                Spacer()
                VStack(alignment: .center) {
                    Text("Species")
                    Text("\(viewModel.selectedPokemon.pokedexDetail?.species?.name ?? "")".capitalizingFirstLetter())
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            HStack(alignment: .top) {
                Spacer()
                VStack(alignment: .center) {
                    Text("Types")
                    LazyVGrid(columns: self.columns, spacing: 20) {
                        ForEach(viewModel.selectedPokemon.pokedexDetail?.types ?? [], id: \.self) { pokeType in
                            getTypeView(pokeType)
                                .foregroundStyle(getTypeColor(pokeType))
                        }
                    }
                }
                Spacer()
            }
            .padding(.top)
        }
        .padding()
    }
    var pokemonMoves: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("🗡️ Pokemon moves")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.bottom)
            LazyVGrid(columns: self.attakColumns, spacing: 5) {
                ForEach(viewModel.selectedPokemon.pokedexDetail?.moves ?? [], id: \.self) { pokeMove in
                    ZStack {
                        HStack {
                            Text("⚔ \(pokeMove.move?.name ?? "")")
                                .foregroundStyle(.white)
                                .font(.caption2)
                            Spacer()
                        }
                        .padding(10)
                    }
                    .background(.ultraThinMaterial)
                    .cornerRadius(30)
                }
                
            }
        }
        .padding()
    }
    var pokemonStats: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("📊 Base stats")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.bottom)
            ForEach(viewModel.selectedPokemon.pokedexDetail?.stats ?? [], id: \.self) { stat in
                HStack(alignment: .center, spacing: 0) {
                    Text(stat.stat?.name ?? "")
                        .font(.caption)
                        .fixedSize(horizontal: true, vertical: true)
                        .frame(maxWidth: 105)
                    VStack(alignment: .center, spacing: 0) {
                        Text("\(stat.base_stat ?? 0)")
                            .font(.footnote)
                        Slider(value: .constant(Double(stat.base_stat ?? 0)), in: range)
                            .tint(getStatColor(stat))
                            .scaleEffect(0.85)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding()
    }
    func getReverseThemeForeground() -> Color {
        return colorScheme == .dark ? .white : .black
    }
    func getTypeView(_ type: PokemonType) -> some View {
        return VStack(alignment: .center, spacing: 5) {
            getTypeIcon(type)
                .resizable()
                .frame(width: 25, height: 25)
            Text(type.type?.name ?? "")
                .font(.footnote)
                .fontWeight(.bold)
        }
    }
    func getTypeColor(_ type: PokemonType) -> Color {
        switch type.type?.name ?? "" {
        case "electric": return .yellow
        case "fire": return .red
        case "normal": return .gray
        case "flying": return .blue
        case "grass": return .green
        case "poison": return .purple
        default: return .gray
        }
    }
    func getStatColor(_ stat: PokemonBaseStats) -> Color {
        switch stat.stat?.name ?? "" {
        case "hp"
            : Color.green
        case "attack"
            : Color.red
        case "defense"
            : Color.yellow
        case "special-attack"
            : Color.purple
        case "special-defense"
            : Color.blue
        case "speed"
            : Color.orange
        default: Color.gray
        }
    }
    func getTypeIcon(_ type: PokemonType) -> Image {
        switch type.type?.name ?? "" {
        case "electric":  return Image(systemName: "bolt.circle.fill")
        case "fire": return Image(systemName: "flame.circle.fill")
        case "normal": return Image(systemName: "o.circle.fill")
        case "flying": return Image(systemName: "bird.circle.fill")
        case "grass": return Image(systemName: "leaf.circle.fill")
        case "poison": return Image(systemName: "ladybug.slash.circle.fill")
        default: return Image(systemName: "questionmark.circle.fill")
        }
    }
}

#Preview {
    PokemonDetailView(viewModel: .init())
}

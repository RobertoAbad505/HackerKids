//
//  PokemonAPIView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/7/25.
//

import SwiftUI

struct PokemonAPIView: View {
    @StateObject var audioManager = AudioManager()
    @ObservedObject var viewModel: PokemonApiViewModel
    
    init(viewModel: PokemonApiViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            if !viewModel.errorFetch {
                pokedexScrollView
            } else {
                errorView
            }
        }
        .onAppear {
            audioManager.playBackgroundMusic(named: "pokemonAudio")
            viewModel.fetchData()
        }
        .onDisappear {
            audioManager.stop()
        }
    }
    var pokedexScrollView: some View {
        ScrollView {
            titleHeader
            VStack {
                ForEach(viewModel.pokemonList.indices, id: \.self) { index in
                    getPokemonView(index)
                        .onAppear {
                            if index == viewModel.pokemonList.count - 3 {
                                viewModel.fetchData()
                            }
                        }
                }
            }
            .padding()
        }
    }
    var titleHeader: some View {
        HStack {
            Text("Pokémon API v2")
                .setTitle3D()
        }
        .background(Color.clear.blur(radius: 5))
    }
    var errorView: some View {
        VStack {
            Text("Error loading data!")
                .setTitle3D()
        }
    }
    func getPokemonView(_ index: Int) -> some View {
        HStack {
            let pokemon = viewModel.pokemonList[index]
            AsyncImage(url: pokemon.calcImageUrl(index + 1)) { image in
                image.resizable()
            } placeholder: {
                Image(systemName: "person.fill.questionmark")
            }
            .frame(width: 120, height: 120)
            VStack(alignment: .leading) {
                Text((pokemon.name ?? "").capitalizingFirstLetter())
                    .font(.title3)
                Text("Pokedex #\(index)")
                    .font(.subheadline)
            }
            .fontDesign(.monospaced)
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
}

#Preview {
    PokemonAPIView(viewModel: .init())
}

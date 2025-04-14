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
        NavigationStack {
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
                if !viewModel.navigateDetail {
                    audioManager.stop()
                }
            }
        }
    }
    var pokedexScrollView: some View {
        NavigationStack {
            titleHeader
            List(viewModel.pokemonList) { pokemon in
                PokedexItemView(viewModel: viewModel,item: pokemon, onSelected: {
                    //play selected pokemon sound
                    audioManager.playSoundEffect(named: "coinFx")
                    viewModel.selectedPokemon = pokemon
                    // Delay para permitir que el sonido suene antes de navegar
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        viewModel.navigateDetail = true
                    }
                })
                .onAppear {
                    if pokemon.id == viewModel.pokemonList.count - 1 {
                        viewModel.fetchData()
                    }
                }
            }
            .background(
                NavigationLink(
                    destination: PokemonDetailView(item: viewModel.selectedPokemon),
                    isActive: $viewModel.navigateDetail,
                    label: { EmptyView() }
                )
                .hidden()
            )
        }
    }
    var titleHeader: some View {
        HStack {
            Text("Pokémon API v2")
                .setTitle3D()
        }
    }
    var errorView: some View {
        VStack {
            Spacer()
            titleHeader
            Text("Error loading data!")
                .setTitle3D(.largeTitle)
            Spacer()
        }
    }
}

#Preview {
    PokemonAPIView(viewModel: .init())
}

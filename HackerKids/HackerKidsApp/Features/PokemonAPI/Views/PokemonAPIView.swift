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
                titleHeader
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
            List(viewModel.pokemonList) { pokemon in
                getPokemonView(pokemon)
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
        .background(Color.clear.blur(radius: 5))
    }
    var errorView: some View {
        VStack {
            Text("Error loading data!")
                .setTitle3D()
        }
    }
    func getPokemonView(_ item: PokedexItem) -> some View {
        Button(action: {
            //play selected pokemon sound
            audioManager.playSoundEffect(named: "coinFx")
            viewModel.selectedPokemon = item
            // Delay para permitir que el sonido suene antes de navegar
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                viewModel.navigateDetail = true
            }
        }, label: {
            HStack {
                AsyncImage(url: item.calcImageUrl()) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "person.fill.questionmark")
                }
                .frame(width: 120, height: 120)
                Button(action: {
                    withAnimation {
                        viewModel.setFavorites(pokemon: item)
                    }
                }, label: {
                    Image(systemName: item.favorite ? "star.fill" :"star")
                })
                .foregroundStyle(.primary)
                Spacer()
                VStack(alignment: .leading) {
                    Text((item.pokemon.name ?? "").capitalizingFirstLetter())
                        .font(.title3)
                    Text("Pokedex #\(item.id)")
                        .font(.subheadline)
                }
                .fontDesign(.monospaced)
                .foregroundStyle(.primary)
                Image(systemName: "chevron.right")
            }
        })
    }
}

#Preview {
    PokemonAPIView(viewModel: .init())
}

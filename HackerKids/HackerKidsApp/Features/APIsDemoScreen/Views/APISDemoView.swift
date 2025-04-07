//
//  APISDemoView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/2/25.
//

import SwiftUI

struct APISDemoView: View {
    @StateObject var ricknMortyViewModel: RickAndMortyViewModel = .init()
    @StateObject var pokemonViewModel: PokemonApiViewModel = .init()

    var body: some View {
        VStack {
            title
            rickAndMortyAPI
            pokemonApi
            Spacer()
        }
        .padding()
    }
    var rickAndMortyAPI: some View {
        NavigationLink(destination: RickAndMortyHome(viewModel: ricknMortyViewModel) , label: {
            HomeButtonView(title: "Rick and Morty API", icon: "atom")
        })
    }
    var pokemonApi: some View {
        NavigationLink(destination: PokemonAPIView(viewModel: pokemonViewModel) , label: {
            HomeButtonView(title: "Pokémon API v2", icon: "atom")
        })
    }
    var title: some View {
        Text("APIs DEMOs")
            .setTitle3D()
    }
}

#Preview {
    APISDemoView()
}

//
//  PokemonDetailView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/11/25.
//

import SwiftUI

struct PokemonDetailView: View {
    var item: PokedexItem
    var index: Int = 0
    init(item: PokedexItem) {
        self.item = item
    }
    var body: some View {
        VStack {
            AsyncImage(url: item.calcImageUrl()) { image in
                image.resizable()
            } placeholder: {
                Image(systemName: "person.fill.questionmark")
            }
            .frame(width: 200, height: 200)
            Text(item.pokemon.name ?? "")
        }
    }
}

#Preview {
    PokemonDetailView(item: PokedexItem(id: 1, pokemon: PokemonItem(name: "Pikachu",
                                                                    url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png")))
}

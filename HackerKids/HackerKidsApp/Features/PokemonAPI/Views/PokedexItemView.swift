//
//  PokedexItemView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/13/25.
//
import Kingfisher
import SwiftUI

struct PokedexItemView: View {
    @Environment(\.colorScheme) var colorScheme
    let item: PokedexItem
    @ObservedObject var viewModel: PokemonApiViewModel
    @State var favorite: Bool = false
    let onSelected: () -> Void
    init(viewModel: PokemonApiViewModel,item: PokedexItem, onSelected: @escaping () -> Void) {
        self.item = item
        self.favorite = item.favorite
        self.viewModel = viewModel
        self.onSelected = onSelected
    }
    var body: some View {
        Button(action: {
            self.onSelected()
        }, label: {
            HStack(alignment: .center, spacing: 15) {
                pokemonImage
                VStack(alignment: .leading) {
                    Text((item.pokemon.name ?? "").capitalizingFirstLetter())
                        .font(.title3)
                    Text("Pokedex #\(item.id)")
                        .font(.subheadline)
                }
                .fontDesign(.monospaced)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .foregroundStyle(colorScheme == .dark ? .white : .black)
        })
    }
    var pokemonImage: some View {
        ZStack {
            KFImage(item.calcImageUrl())
                .placeholder {
                    ProgressView()
                }
                .retry(maxCount: 3, interval: .seconds(2))
                .cacheOriginalImage()
                .fade(duration: 0.25)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    favoriteBtn
                }
            }
            .frame(width: 100, height: 80)
        }
    }
    var favoriteBtn: some View {
        Button(action: {
            withAnimation {
                print("SetFavorite Pokémon #\(item.id)")
                self.favorite.toggle()
                viewModel.setFavorites(pokemon: item)
            }
        }, label: {
            Image(systemName: favorite ? "heart.fill" :"heart")
                .resizable()
                .frame(width: 20, height: 20)
        })
        .foregroundStyle(.red)
    }
    var navigateIcon: some View {
        Image(systemName: "chevron.right")
    }
}

#Preview {
    PokedexItemView(viewModel: .init(),
                    item: .init(id: 25,pokemon: PokemonItem(name: "Test",url: "url")),
                    onSelected: { //code to navigate detail item view
                    })
}

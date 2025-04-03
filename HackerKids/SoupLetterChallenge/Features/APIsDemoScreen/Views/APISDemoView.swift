//
//  APISDemoView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/2/25.
//

import SwiftUI

struct APISDemoView: View {
    @StateObject var ricknMortyViewModel: RickAndMortyViewModel = .init()
    var body: some View {
        VStack {
            Text("APIs Demo")
                .padding()
                .font(.largeTitle)
            rickAndMortyAPI
//            pokemonApi
            Spacer()
        }
        .padding()
    }
    var rickAndMortyAPI: some View {
        NavigationLink(destination: RickAndMortyHome(viewModel: ricknMortyViewModel) , label: {
            HomeButtonView(title: "Rick and Morty API", icon: "atom")
        })
    }
}

#Preview {
    APISDemoView()
}

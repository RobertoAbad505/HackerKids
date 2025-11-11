//
//  AppState.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 11/10/25.
//

import Foundation

final class AppState: ObservableObject {
    @Published var aboutViewModel = AboutAppViewModel()
    @Published var demosViewModel = PortfolioViewModel()
    @Published var pokemonViewModel = PokemonApiViewModel()
    @Published var rickAndMortyViewModel = RickAndMortyViewModel()
    @Published var weatherViewModel = WeatherViewModel()
    @Published var localizationManager = LocationManager()
}

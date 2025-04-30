//
//  PortfolioViewModel.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/24/25.
//

import Foundation

class PortfolioViewModel: ObservableObject {
    let features: [FeatureModel] = [
        FeatureModel(
            id: 0,
            name: "Rick and Morty API",
            description: "Display a list of Rick and Morty characters by fetching data from the public open API (https://rickandmortyapi.com). Built with MVVM architecture, infinite scrolling, and pagination.",
            lclstring: LocalizedStringResource("portfolio.rickAndMorty.description"),
            type: .rickAndMorty
        ),
        FeatureModel(
            id: 1,
            name: "Pokémon API",
            description: "A Pokédex tool built with SwiftUI. Includes public open API (https://pokeapi.co/docs/v2/) integration, infinite scrolling, search functionality, and pagination. Explore detailed stats, abilities, and types for each Pokémon.",
            lclstring: LocalizedStringResource("portfolio.pokemon.description"),
            type: .pokemon
        ),
        FeatureModel(
            id: 2,
            name: "SoupChallenge Game!",
            description: "A word search game built with SwiftUI. Find all the words as quickly as you can to win the challenge!",
            lclstring: LocalizedStringResource("portfolio.soupgame.description"),
            type: .soupChallenge
        ),
        FeatureModel(
            id: 3,
            name: "WeatherApp",
            description: "Get real-time weather updates based on your current location and integrate with the OpenWeatherMap API(https://openweathermap.org/api/). Uses GPS to display current conditions, forecasts, and more.",
            lclstring: LocalizedStringResource("portfolio.weather.description"),
            type: .weather
        )
    ]
}

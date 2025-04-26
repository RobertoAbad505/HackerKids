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
            description: "Populate a view with Rick and Morty characters.",
            type: .rickAndMorty
        ),
        FeatureModel(
            id: 1,
            name: "Pokémon API",
            description: "A pokedex tool made with SwiftUI. API call, Infinite scroll, search, and pagination. Navigate to each Pokémon detail page to see its stats, abilities, and types.",
            type: .pokemon
        ),
        FeatureModel(
            id: 2,
            name: "SoupChallenge game!",
            description: "Letter soup game created with SwiftUI. Go as fast as you can to fill the soup with all the letters!",
            type: .soupChallenge
        ),
        FeatureModel(
            id: 3,
            name: "WeatherApp",
            description: "All weather info from your current location. Using your device GPS, you can see the current weather, forecast, and more.",
            type: .weather
        ),
        FeatureModel(
            id: 4,
            name: "SoupChallenge game!",
            description: "Letter soup game created with SwiftUI. Go as fast as you can to fill the soup with all the letters!",
            type: .pokemon
        ),
        FeatureModel(
            id: 5,
            name: "SoupChallenge game!",
            description: "Letter soup game created with SwiftUI. Go as fast as you can to fill the soup with all the letters!",
            type: .pokemon
        )
    ]
}

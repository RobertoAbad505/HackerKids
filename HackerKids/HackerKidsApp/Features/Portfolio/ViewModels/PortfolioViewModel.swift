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
            name: "Modern UI views",
            description: "",
            lclstring: LocalizedStringResource("portfolio.rickAndMorty.description"),
            type: .rickAndMorty
        ),
        FeatureModel(
            id: 1,
            name: "ListUI dynamics",
            description: "",
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

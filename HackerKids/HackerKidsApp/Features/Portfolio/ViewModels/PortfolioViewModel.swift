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
            name: "HandVision!",
            description: "Vision and hand tracking to control a virtual hand.",
            lclstring: LocalizedStringResource("portfolio.handtracking.description"),
            type: .handTracking,
            icon: "🤟"
        ),
        FeatureModel(
            id: 1,
            name: "Flip a coin!",
            description: "Flip a coin and test your luck!",
            lclstring: LocalizedStringResource("portfolio.flipcoin.description"),
            type: .flipCoin,
            icon: "🪙"
        ),
        FeatureModel(
            id: 2,
            name: "WeatherApp",
            description: "Get real-time weather updates based on your current location and integrate with the OpenWeatherMap API(https://openweathermap.org/api/). Uses GPS to display current conditions, forecasts, and more.",
            lclstring: LocalizedStringResource("portfolio.weather.description"),
            type: .weather,
            icon: "🌤️"
        ),
        FeatureModel(
            id: 3,
            name: "SoupChallenge Game!",
            description: "A word search game built with SwiftUI. Find all the words as quickly as you can to win the challenge!",
            lclstring: LocalizedStringResource("portfolio.soupgame.description"),
            type: .soupChallenge,
            icon: "🧩"
        ),
        FeatureModel(
            id: 4,
            name: "MoviesApp",
            description: "Browse recent movies, overviews, and more. Powered by the TMDb API(https://www.themoviedb.org/documentation/api).",
            lclstring: LocalizedStringResource("portfolio.movies.description"),
            type: .movies,
            icon: "🎬"
        ),
        FeatureModel(
            id: 5,
            name: "Modern UI views",
            description: "",
            lclstring: LocalizedStringResource("portfolio.rickAndMorty.description"),
            type: .rickAndMorty,
            icon: "🚀"
        ),
        FeatureModel(
            id: 6,
            name: "ListUI dynamics",
            description: "",
            lclstring: LocalizedStringResource("portfolio.pokemon.description"),
            type: .pokemon,
            icon: "👾"
        )
    ]
}

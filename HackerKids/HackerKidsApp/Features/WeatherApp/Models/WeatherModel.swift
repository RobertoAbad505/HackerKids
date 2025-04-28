//
//  WeatherModel.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/25/25.
//

import Foundation

struct WeatherModel: Codable {
    let coord: Coord?
    let name: String?
    let main: Main?
    let timezone: Int?
    let dt: Int?
    let weather: [Weather]?
    let wind: Wind?
    let sys: Sys?
    struct Wind: Codable {
        let speed: Double
        let deg: Int?
    }
    struct Weather: Codable {
        let id: Int?
        let main: String?
        let description: String?
        let icon: String?
    }
    struct Coord: Codable {
        let lon: Double
        let lat: Double
    }
    struct Sys: Codable {
        let type: Int?
        let id: Int?
        let country: String?
        let sunrise: Int?
        let sunset: Int?
    }
    struct Main: Codable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
        let sea_level: Int
        let grnd_level: Int
    }
}

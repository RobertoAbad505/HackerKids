//
//  WeatherModel.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/25/25.
//

import Foundation

struct WeatherModel: Decodable {
    let coord: Coord?
    let name: String?
    let main: Main?
    let timezone: Int?
    let weather: [Weather]?
    let sys: Sys?
    struct Weather: Decodable {
        let id: Int?
        let main: String?
        let description: String?
        let icon: String?
    }
    struct Coord: Decodable {
        let lon: Double
        let lat: Double
    }
    struct Sys: Decodable {
        let type: Int?
        let id: Int?
        let country: String?
        let sunrise: Int?
        let sunset: Int?
    }
    struct Main: Decodable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
        let sea_level: Int
        let grnd_level: Int
    }
    /*
     {
         "coord": {
             "lon": -74.006,
             "lat": 40.7128
         },
         "weather": [
             {
                 "id": 804,
                 "main": "Clouds",
                 "description": "overcast clouds",
                 "icon": "04n"
             }
         ],
         "base": "stations",
         "main": {
             "temp": 291.01,
             "feels_like": 290.76,
             "temp_min": 288.69,
             "temp_max": 293.27,
             "pressure": 1018,
             "humidity": 73,
             "sea_level": 1018,
             "grnd_level": 1017
         },
         "visibility": 10000,
         "wind": {
             "speed": 5.66,
             "deg": 180
         },
         "clouds": {
             "all": 100
         },
         "dt": 1745634065,
         "sys": {
             "type": 1,
             "id": 4610,
             "country": "US",
             "sunrise": 1745575330,
             "sunset": 1745624724
         },
         "timezone": -14400,
         "id": 5128581,
         "name": "New York",
         "cod": 200
     }

     **/
    
}

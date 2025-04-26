//
//  WeatherServices.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/25/25.
//
import Combine
import Foundation

class WeatherServices {
    private var network: NetworkManagerProtocol {
        #if ISDEBUG
        return NetworkManagerMock()
        #else
        return NetworkManager()
        #endif
    }
    
    
    func fetchWeather(_ url: URL) -> AnyPublisher<WeatherModel, NetworkError> {
        return network.fetch(url)
    }
}

//
//  PokemonServices.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/7/25.
//

import Foundation
import Combine

class PokemonServices {
    private var network: NetworkManager = NetworkManager()
    
    func fetchData(_ url: URL) -> AnyPublisher<PokedexResponse, NetworkError> {
        return network.fetch<PokedexResponse>(url)
    }
}

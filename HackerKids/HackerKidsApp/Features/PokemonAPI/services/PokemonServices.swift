//
//  PokemonServices.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/7/25.
//

import Foundation
import Combine

class PokemonServices {
    private var network: NetworkManagerProtocol {
        #if ISDEBUG
        return NetworkManagerMock()
        #else
        return NetworkManager()
        #endif
    }
    
    func fetchPokedexPage(_ url: URL) -> AnyPublisher<PokedexResponse, NetworkError> {
        if url.absoluteString.contains("offset=0") {
            return NetworkManagerMock().fetch<PokedexResponse>(url)
        } else {
            return network.fetch<PokedexResponse>(url)
        }
    }
    func fetchPokedexDetail(_ url: URL) -> AnyPublisher<PokedexDetail, NetworkError> {
        return network.fetch<PokedexDetail>(url)
    }
}

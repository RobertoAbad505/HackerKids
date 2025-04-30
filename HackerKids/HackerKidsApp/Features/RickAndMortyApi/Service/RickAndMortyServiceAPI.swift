//
//  RickAndMortyServiceAPI.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/2/25.
//

import Foundation
import Combine

class RickAndMortyServiceAPI {
    
    private var network: NetworkManagerProtocol {
        #if ISDEBUG
        return NetworkManagerMock()
        #else
        return NetworkManager()
        #endif
    }
    
    func fetchQuery(url: URL) -> AnyPublisher<CharactersResponse, NetworkError> {
        if url.absoluteString.contains("page=1") {
            return NetworkManagerMock().fetch<CharactersResponse>(url)
        }
        return network.fetch<CharactersResponse>(url)
    }
}

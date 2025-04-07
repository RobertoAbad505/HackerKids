//
//  RickAndMortyServiceAPI.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/2/25.
//

import Foundation
import Combine

class RickAndMortyServiceAPI {
    
    var network: NetworkManagerProtocol {
//        if 1 > 1 { //#IS_DEVELOPMENT
//            return NetworkManagerMock()
//        }
        return NetworkManager()
    }
    
    func fetchQuery(url: URL) -> AnyPublisher<CharactersResponse, NetworkError> {
        return network.fetch<CharactersResponse>(url)
    }
}

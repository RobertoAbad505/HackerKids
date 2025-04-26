//
//  AboutDeveloperServices.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/5/25.
//

import Combine
import Foundation

class AboutDeveloperServices {
    private var network: NetworkManagerProtocol {
        #if ISDEBUG
        return NetworkManagerMock()
        #else
        return NetworkManager()
        #endif
    }
    
    func fetchQuery(url: URL) -> AnyPublisher<GitHubUser, NetworkError> {
        return network.fetch<GitHubUser>(url, .convertFromSnakeCase)
    }
}

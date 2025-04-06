//
//  AboutDeveloperServices.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/5/25.
//

import Combine
import Foundation

class AboutDeveloperServices {
    let network = NetworkManager()
    
    func fetchQuery(url: URL) -> AnyPublisher<GitHubUser, NetworkError> {
        return network.fetch<GitHubUser>(url, .convertFromSnakeCase)
    }
}

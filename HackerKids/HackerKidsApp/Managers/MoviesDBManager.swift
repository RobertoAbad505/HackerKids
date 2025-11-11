//
//  MoviesDBManager.swift
//  MovieBrowserApp
//
//  Created by Roberto Ramirez on 10/9/25.
//

import Foundation

public class MoviesDBManager {
    
    //Singleton to avoid multiple autentications attempts and multiple sessionIDs
    static let shared: MoviesDBManager = MoviesDBManager()
    private init() {}
    
    let apiKey: String = "bf37f9a4b4c70dfd3cd0b33655fcec82"
    private let apiToken: String = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiZjM3ZjlhNGI0YzcwZGZkM2NkMGIzMzY1NWZjZWM4MiIsIm5iZiI6MTU5NjczODgxNy40ODMsInN1YiI6IjVmMmM0ZDAxNTVjMWY0MDAzNzYzMWU2YSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.nF-nNwKnaHxcnnj8GAED1Ejh-2CiRd-Zm2ofmj4-KdQ"
    static var sessionID: String = ""
}

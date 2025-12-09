//
//  FeatureModel.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/24/25.
//

import Foundation

struct FeatureModel: Identifiable {
    let id: Int
    let name: String
    let description: String
    let lclstring: LocalizedStringResource
    let type: Feature
    let icon: String
}
enum Feature: String, CaseIterable {
    case pokemon
    case rickAndMorty
    case soupChallenge
    case weather
    case movies
    case flipCoin
    case handTracking
}

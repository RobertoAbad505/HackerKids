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
    let type: Feature
}
enum Feature: String, CaseIterable {
    case pokemon
    case rickAndMorty
    case soupChallenge
    case weather
}

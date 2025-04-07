//
//  ChallengeModel.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 12/14/24.
//

struct ChallengeModel {
    var diffuculty: DifficultyLevel = .easy
    var challengerName: String = ""
    var challengeWords: [String] = []
    init() {
        self.diffuculty = .medium
        self.challengerName = "Roberto P1"
        self.challengeWords = []
    }
}

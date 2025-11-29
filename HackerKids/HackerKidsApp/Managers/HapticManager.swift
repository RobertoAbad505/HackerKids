//
//  HapticManager.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 11/28/25.
//

import CoreHaptics
import SwiftUI

final class HapticManager {
    static let shared = HapticManager()
    
    private let generatorLight = UIImpactFeedbackGenerator(style: .light)
    private let generatorMedium = UIImpactFeedbackGenerator(style: .medium)
    private let generatorHeavy = UIImpactFeedbackGenerator(style: .heavy)

    func flipStart() {
        generatorLight.prepare()
        generatorLight.impactOccurred()
    }

    func flipLandingHeads() {
        generatorMedium.prepare()
        generatorMedium.impactOccurred(intensity: 0.8)
    }

    func flipLandingTails() {
        generatorHeavy.prepare()
        generatorHeavy.impactOccurred(intensity: 1)
    }
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        NotificationCenter.default.post(name: .deviceShaken, object: nil)
    }
}

extension Notification.Name {
    static let deviceShaken = Notification.Name("deviceShaken")
}

//
//  AudioManager.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/7/25.
//

import AVFoundation

class AudioManager: ObservableObject {
    private var player: AVAudioPlayer?

    func playBackgroundMusic(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("Audio file not found.")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1 // Repetir indefinidamente
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Error al reproducir audio: \(error)")
        }
    }

    func stop() {
        player?.stop()
        player = nil
    }
}

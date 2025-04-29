//
//  AudioManager.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/7/25.
//

import AVFoundation

class AudioManager: ObservableObject {
    private var player: AVAudioPlayer?
    private var soundEffectPlayer: AVAudioPlayer?
    func playBackgroundMusic(named name: String) -> Bool {
        guard player == nil else {
            player?.play()
            return true
        }
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("❌Audio file not found.")
            return false
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1 // Repetir indefinidamente
            player?.volume = 0.2
            player?.prepareToPlay()
            player?.play()
            return true
        } catch {
            print("❌Error al reproducir audio: \(error)")
        }
        return false
    }
    func playSoundEffect(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("❌sound FX file not found.")
            return
        }
        do {
            soundEffectPlayer = try AVAudioPlayer(contentsOf: url)
            soundEffectPlayer?.volume = 1.0
            soundEffectPlayer?.play()
        } catch {
            print("❌Error playing sound effect: \(error)")
        }
    }

    func stop() {
        player?.stop()
        player = nil
    }
    func playSelectionSound() {
        AudioServicesPlaySystemSound(1104) // "Tock" como el de los botones del teclado
    }
}

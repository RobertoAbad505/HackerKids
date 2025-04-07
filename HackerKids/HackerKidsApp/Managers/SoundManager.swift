//
//  SoundManager.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 9/27/24.
//

import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    var audioPlayer: AVAudioPlayer?

    // Función para reproducir un sonido
    func playSound(soundFileName: String, fileType: String = "mp3") {
        if let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: fileType) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Error al reproducir sonido: \(error.localizedDescription)")
            }
        } else {
            print("Archivo de sonido no encontrado")
        }
    }
}

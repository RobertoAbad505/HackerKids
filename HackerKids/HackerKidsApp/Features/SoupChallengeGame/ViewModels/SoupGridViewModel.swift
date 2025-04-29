//
//  SoupGridViewModel.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 9/25/24.
//
import AVFoundation
import Foundation
import UIKit

class SoupGridViewModel: ObservableObject {
    @Published var gridSize: Int = 0
    @Published var difficultyLevel: DifficultyLevel = .easy
    @Published var grid: [[Character]] = []
    @Published var challengeWords: [WordChallenge] = [
        WordChallenge(word: "GREEN"),
        WordChallenge(word:"OSO"),
        WordChallenge(word:"ROBERTO"),
        WordChallenge(word:"RAMIREZ"),
        WordChallenge(word:"SATURNO"),
        WordChallenge(word:"APOLLO"),
        WordChallenge(word:"ZEBRA"),
        WordChallenge(word:"STAR"),
        WordChallenge(word:"CALIFORNIA"),
        WordChallenge(word:"ICEBERG")
    ]
    @Published var selectedPositions: [GridPosition] = [] // Posiciones seleccionadas temporalmente
    @Published var correctWordsPositions: Set<GridPosition> = [] // Palabras correctamente seleccionadas
    @Published var foundWords: [WordChallenge] = [] // Palabras encontradas
    @Published var win: Bool = false
    @Published var counter: Int = 0
    let isIPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    @Published private(set) var tiempoTranscurrido = 0 // Tiempo en segundos
    private var timer: Timer?
    private var wordDirection: Direction?

    var tiempoFormateado: String {
        let minutos = tiempoTranscurrido / 60
        let segundosRestantes = tiempoTranscurrido % 60
        return String(format: "%02d:%02d", minutos, segundosRestantes)
    }

    func startGame() {
        //START NEW GAME
        //GENERAR ARRAY VACIO
        let gridLimit = getGridSize()
        gridSize = gridLimit
        grid = Array(repeating: Array(repeating: SoupChallengeConstants.emptyChar, count: gridLimit), count: gridLimit)
        selectedPositions = []
        correctWordsPositions = []
        foundWords.removeAll()
        win = false
        //COLOCAR LAS PALABRAS
        placeWordsInGrid()
        // Rellenar el resto con letras aleatorias
        fillEmptySpaces()
        detenerTimer()
        tiempoTranscurrido = 0
        iniciarTimer()
    }
    func getGridSize() -> Int {
        if isIPad {
            return 15
        } else {
            return 14
        }
    }

    func generateRandomGrid(_ size: Int) {
        grid = (0..<size).map { _ in
            (0..<size).map { _ in
                SoupChallengeConstants.alphabet.randomElement() ?? "A"
            }
        }
    }
    func placeWordsInGrid() {
        for word in challengeWords {
            var placed = false
            while !placed {
                //Si la palabra es muy larga no puede ser añadidda
                if word.word.count > gridSize {
                    placed = true
                }
                //Definimos la direccion de la palabra
                let direction = Direction.random()
                //definimos el punto de inicio de forma aleatoria
                let startRow = Int.random(in: 0..<gridSize)
                let startCol = Int.random(in: 0..<gridSize)
                //Verificar si la palabra cabe we
                if canPlaceWord(word.word, direction: direction, row: startRow, col: startCol) {
                    //Insertar la palabra como la direccion lo marca
                    placeWord(word.word, direction: direction, row: startRow, col: startCol)
                    placed = true
                }
            }
        }
    }
    // Verificar si la palabra puede ser colocada
    func canPlaceWord(_ word: String, direction: Direction, row: Int, col: Int) -> Bool {
        let length = word.count
        switch direction {
        case .horizontal:
            return col + length <= gridSize && (0..<length).allSatisfy { grid[row][col + $0] == SoupChallengeConstants.emptyChar }
        case .vertical:
            return row + length <= gridSize && (0..<length).allSatisfy { grid[row + $0][col] == SoupChallengeConstants.emptyChar }
        case .diagonal:
            return row + length <= gridSize && col + length <= gridSize && (0..<length).allSatisfy { grid[row + $0][col + $0] == SoupChallengeConstants.emptyChar }
        }
    }
    // Colocar la palabra en el grid
    func placeWord(_ word: String, direction: Direction, row: Int, col: Int) {
        let letters = Array(word)
        for (index, letter) in letters.enumerated() {
            switch direction {
            case .horizontal:
                grid[row][col + index] = letter
            case .vertical:
                grid[row + index][col] = letter
            case .diagonal:
                grid[row + index][col + index] = letter
            }
        }
    }
    // Rellenar los espacios vacíos con letras aleatorias
    func fillEmptySpaces() {
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if grid[row][col] == SoupChallengeConstants.emptyChar {
                    grid[row][col] = SoupChallengeConstants.alphabet.randomElement() ?? "A"
                }
            }
        }
    }
    // Validar la selección actual de letras
    func validateSelection() {
        // Convert the selected characters to a string
        let selectedWord = selectedPositions.map { String(grid[$0.row][$0.col]) }.joined()
        
        //Obtener las palabras restantes
//        let remainingChallengeWords = challengeWords.filter { !foundWords.contains($0) }
        let remainingChallengeWords = challengeWords.filter { word in
            return !foundWords.contains(where: { $0.word == word.word})
        }
        print("secuencia ingresada: \(selectedWord), POS: \(selectedPositions.last)")
        if selectedPositions.count > 1 {
            //validar click en columna o fila consecuente
            if validOnePositionMove() == nil {
                print("New selected direction!! RESTART SEQUENCE")
                if let last = selectedPositions.last {
                    selectedPositions = [last]
                    return
                }
            }
        }
        // Verify if the selected word is in the list of valid words
        let possibleWords = remainingChallengeWords.filter { $0.word.hasPrefix(selectedWord) }
        if  possibleWords.count  == 1, let _ = remainingChallengeWords.first(where: { challenge in
            return challenge.word == selectedWord
        }) {
            // Mark all selected positions as correct
            for position in selectedPositions {
                correctWordsPositions.insert(position) // Store individual positions as (row, col)
            }
            foundWords.append(WordChallenge(word: selectedWord, found: true))
            // Limpiar las posiciones seleccionadas después de validar
            clearCurrentSelection()
            wordDirection = nil
            if challengeWords.count == foundWords.count {
                win = true
                counter += 1
                detenerTimer()
            }
            self.challengeWords = challengeWords.sorted { first, second in
                let firstIsFound = foundWords.contains(where: { $0.word == first.word })
                let secondIsFound = foundWords.contains(where: { $0.word == second.word })

                // Si first no está y second sí está → first va primero (return true)
                // Si first sí está y second no → second va primero (return false)
                // Si ambos están o ambos no están → orden original
                return firstIsFound == false && secondIsFound == true
            }
            playSelectionSound()
        } else {
            //La palabra correcta no es la misma, validar inicio de secuencia entonces
            // Obtener las primeras letras seleccionadas
            let prefix = selectedPositions.prefix(selectedPositions.count).map { String(grid[$0.row][$0.col]) }.joined()
            
            // Verificar si alguna palabra esperada comienza con ese prefijo
            if !remainingChallengeWords.contains(where: { $0.word.hasPrefix(prefix) }) {
                //se han seleccionado solo errores
                print("No existe esta secuencia: \(selectedWord)")
                wordDirection = nil
                if let last = selectedPositions.last {
                    selectedPositions = [last]
                }
            }
        }
    }
    func validOnePositionMove() -> Direction? {
        let first = selectedPositions.first!
        let from = selectedPositions[selectedPositions.count - 2]
        let to = selectedPositions.last!
        
        //abs() determina el valor absoluto entre dos numeros (negativos o positivos) y devuelve la distancia entre ellos.
        // buscar que el valor absoluto siempre sea 1, lo que significa que todos los movimientos hechos son letras adyacentes.
        // Determinar la dirección inicial si aún no se ha establecido
        if wordDirection == nil {
            // Dirección horizontal
            if first.row == to.row && abs(first.col - to.col) == 1 {
                wordDirection = .horizontal
            }
            // Dirección vertical
            else if first.col == to.col && abs(first.row - to.row) == 1 {
                wordDirection = .vertical
            }
            // Dirección diagonal
            else if abs(first.row - to.row) == 1 && abs(first.col - to.col) == 1 {
                wordDirection = .diagonal
            } else {
                // Movimiento inicial inválido
                return nil
            }
        }
        
        // Validar que el movimiento actual es consistente con la dirección inicial
        switch wordDirection {
        case .horizontal:
            // Movimiento horizontal válido: misma fila, columnas adyacentes
            if from.row == to.row && abs(from.col - to.col) == 1 {
                return wordDirection
            }
        case .vertical:
            // Movimiento vertical válido: misma columna, filas adyacentes
            if from.col == to.col && abs(from.row - to.row) == 1 {
                return wordDirection
            }
        case .diagonal:
            // Movimiento diagonal válido: diferencia absoluta de 1 en filas y columnas
            if abs(from.row - to.row) == 1 && abs(from.col - to.col) == 1 {
                return wordDirection
            }
        case .none:
            break
        }
        
        // Si el movimiento actual no coincide con la dirección inicial, es inválido
        wordDirection = nil
        return nil
    }
    func getDirection(_ first: (row: Int, col: Int), second: (row: Int, col: Int)) -> Direction? {
        if first.row == second.row {
            return .horizontal
        } else if first.col == second.col {
            return .vertical
        } else if abs(first.row - second.row) == abs(first.col - second.col) {
            return .diagonal
        }
        return nil // Dirección no válida
    }
    
    func isCorrectPosition(row: Int, col: Int) -> Bool {
        return correctWordsPositions.contains(GridPosition(row: row, col: col))
    }
    // Limpiar las posiciones seleccionadas temporalmente
    func clearCurrentSelection() {
        selectedPositions.removeAll()
        self.wordDirection
    }
    // Comprobar si una palabra ya ha sido encontrada
    func isWordFound(_ word: WordChallenge) -> Bool {
        return foundWords.first(where: { $0.word == word.word}) != nil
    }
    // Inicia el temporizador
    func iniciarTimer() {
        detenerTimer() // Asegura que no haya un timer previo corriendo
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tiempoTranscurrido += 1
        }
    }

    // Detiene el temporizador
    func detenerTimer() {
        timer?.invalidate()
        timer = nil
    }
    func addChallenge(challenge: ChallengeModel?) {
        if let challenge {
            self.difficultyLevel = challenge.diffuculty
            self.challengeWords = challenge.challengeWords.map({
                return WordChallenge(word: $0)
            })
        }
        startGame()
    }

    func playSelectionSound() {
        AudioServicesPlaySystemSound(1104) // "Tock" como el de los botones del teclado
    }
}
enum DifficultyLevel: String, Identifiable, CaseIterable {
    case easy
    case medium
    case hard
    case impossible
    case custom
    
    var id: String { self.rawValue }
}
// Definir las direcciones posibles
enum Direction {
    case horizontal
    case vertical
    case diagonal
    
    static func random() -> Direction {
        return [.horizontal, .vertical, .diagonal].randomElement()!
    }
}
struct GridPosition: Hashable {
    let row: Int
    let col: Int
}


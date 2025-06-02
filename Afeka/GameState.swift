//
//  GameState.swift
//  Afeka
//
//  Created by Adam Agbaria on 31/05/2025.
//

import Foundation
import Combine

enum GamePhase: String, CaseIterable {
    case setup = "setup"
    case locationSetup = "locationSetup"
    case playing = "playing"
    case results = "results"
}

enum BattleResult: String, CaseIterable {
    case player1Wins = "player1Wins"
    case player2Wins = "player2Wins"
    case tie = "tie"
}

struct GameRound: Identifiable {
    let id = UUID()
    let roundNumber: Int
    let player1Card: Card
    let player2Card: Card
    let result: BattleResult
}

class GameState: ObservableObject {
    @Published var phase: GamePhase = .setup
    @Published var player1: Player?
    @Published var player2: Player?
    @Published var currentPlayer1Card: Card?
    @Published var currentPlayer2Card: Card?
    @Published var currentRound: Int = 0
    @Published var maxRounds: Int = 10
    @Published var rounds: [GameRound] = []
    @Published var isGameActive: Bool = false
    
    private var deck: [Card] = []
    private var usedCards: [Card] = []
    
    init() {
        resetGame()
    }
    
    func startGame() {
        guard player1 != nil && player2 != nil else { return }
        isGameActive = true
        currentRound = 0
        rounds = []
        deck = Card.createDeck()
        usedCards = []
        
        // Reset player scores
        player1?.score = 0
        player2?.score = 0
    }
    
    func playRound() -> GameRound? {
        guard isGameActive && currentRound < maxRounds else { return nil }
        guard deck.count >= 2 else { return nil }
        
        currentRound += 1
        
        // Draw cards for both players
        let player1Card = deck.removeFirst()
        let player2Card = deck.removeFirst()
        
        currentPlayer1Card = player1Card
        currentPlayer2Card = player2Card
        
        // Determine winner
        let result: BattleResult
        if player1Card.strength > player2Card.strength {
            result = .player1Wins
            player1?.score += 1
        } else if player2Card.strength > player1Card.strength {
            result = .player2Wins
            player2?.score += 1
        } else {
            result = .tie
            // Ties go to "house" - no points awarded
        }
        
        // Create round record
        let round = GameRound(
            roundNumber: currentRound,
            player1Card: player1Card,
            player2Card: player2Card,
            result: result
        )
        
        rounds.append(round)
        usedCards.append(contentsOf: [player1Card, player2Card])
        
        // Check if game is over
        if currentRound >= maxRounds {
            isGameActive = false
            phase = .results
        }
        
        return round
    }
    
    func resetGame() {
        phase = .setup
        player1 = nil
        player2 = nil
        currentPlayer1Card = nil
        currentPlayer2Card = nil
        currentRound = 0
        rounds = []
        isGameActive = false
        deck = []
        usedCards = []
    }
    
    func getWinner() -> Player? {
        guard let p1 = player1, let p2 = player2 else { return nil }
        
        if p1.score > p2.score {
            return p1
        } else if p2.score > p1.score {
            return p2
        } else {
            return nil // Tie
        }
    }
} 
//
//  GameState.swift
//  Afeka
//
//  Created by Adam Agbaria on 31/05/2025.
//

import Foundation

enum GamePhase {
    case setup
    case locationSetup
    case playing
    case results
}

enum BattleResult {
    case player1Wins
    case player2Wins
    case tie
}

struct GameRound {
    let roundNumber: Int
    let player1Card: Card
    let player2Card: Card
    let result: BattleResult
    
    init(roundNumber: Int, player1Card: Card, player2Card: Card) {
        self.roundNumber = roundNumber
        self.player1Card = player1Card
        self.player2Card = player2Card
        
        if player1Card.strength > player2Card.strength {
            self.result = .player1Wins
        } else if player2Card.strength > player1Card.strength {
            self.result = .player2Wins
        } else {
            self.result = .tie // Ties go to the house
        }
    }
}

class GameState: ObservableObject {
    @Published var phase: GamePhase = .setup
    @Published var player1: Player?
    @Published var player2: Player?
    @Published var currentRound: Int = 0
    @Published var rounds: [GameRound] = []
    @Published var deck: [Card] = []
    @Published var isGameActive: Bool = false
    @Published var currentPlayer1Card: Card?
    @Published var currentPlayer2Card: Card?
    
    let maxRounds = 10
    
    init() {
        resetGame()
    }
    
    func resetGame() {
        phase = .setup
        player1 = nil
        player2 = nil
        currentRound = 0
        rounds = []
        deck = Card.createDeck()
        isGameActive = false
        currentPlayer1Card = nil
        currentPlayer2Card = nil
    }
    
    func startGame() {
        guard let p1 = player1, let p2 = player2 else { return }
        
        deck = Card.createDeck()
        currentRound = 0
        rounds = []
        isGameActive = true
        phase = .playing
        
        // Reset scores
        player1?.score = 0
        player2?.score = 0
    }
    
    func playRound() -> GameRound? {
        guard isGameActive,
              currentRound < maxRounds,
              deck.count >= 2 else {
            return nil
        }
        
        let card1 = deck.removeFirst()
        let card2 = deck.removeFirst()
        
        currentPlayer1Card = card1
        currentPlayer2Card = card2
        
        currentRound += 1
        let round = GameRound(roundNumber: currentRound, player1Card: card1, player2Card: card2)
        rounds.append(round)
        
        // Update scores
        switch round.result {
        case .player1Wins:
            player1?.incrementScore()
        case .player2Wins:
            player2?.incrementScore()
        case .tie:
            // Ties go to the house (no score)
            break
        }
        
        // Check if game is over
        if currentRound >= maxRounds {
            endGame()
        }
        
        return round
    }
    
    func endGame() {
        isGameActive = false
        phase = .results
    }
    
    func getWinner() -> Player? {
        guard let p1 = player1, let p2 = player2 else { return nil }
        
        if p1.score > p2.score {
            return p1
        } else if p2.score > p1.score {
            return p2
        } else {
            return nil // It's a tie
        }
    }
} 
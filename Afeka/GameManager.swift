//
//  GameManager.swift
//  Afeka
//
//  Created by Adam Agbaria on 31/05/2025.
//

import Foundation
import Combine

class GameManager: ObservableObject {
    @Published var gameState = GameState()
    @Published var timeUntilNextFlip: Int = 5
    @Published var isCountingDown: Bool = false
    
    private var gameTimer: Timer?
    private var countdownTimer: Timer?
    private let cardFlipInterval: TimeInterval = 5.0
    
    init() {
        // Set up automatic AI opponent for single player mode
        setupAIOpponent()
    }
    
    private func setupAIOpponent() {
        // Create an AI opponent for the other side
        let aiPlayer = Player(name: "AI Opponent", side: .west)
        gameState.player2 = aiPlayer
    }
    
    func setupPlayer(name: String, side: PlayerSide, location: CLLocationCoordinate2D?) {
        let player = Player(name: name, side: side, location: location)
        gameState.player1 = player
        
        // Update AI opponent to be on the opposite side
        if let aiPlayer = gameState.player2 {
            let oppositeSide: PlayerSide = (side == .east) ? .west : .east
            gameState.player2 = Player(name: "AI Opponent", side: oppositeSide)
        }
        
        gameState.phase = .playing
    }
    
    func startGame() {
        guard gameState.player1 != nil && gameState.player2 != nil else { return }
        
        gameState.startGame()
        startGameTimer()
    }
    
    private func startGameTimer() {
        stopGameTimer()
        
        // Start countdown
        timeUntilNextFlip = Int(cardFlipInterval)
        isCountingDown = true
        
        // Start countdown timer
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateCountdown()
        }
        
        // Start game timer for card flips
        gameTimer = Timer.scheduledTimer(withTimeInterval: cardFlipInterval, repeats: true) { [weak self] _ in
            self?.flipCards()
        }
        
        // Play first round immediately
        DispatchQueue.main.async {
            self.flipCards()
        }
    }
    
    private func updateCountdown() {
        if timeUntilNextFlip > 0 {
            timeUntilNextFlip -= 1
        } else {
            timeUntilNextFlip = Int(cardFlipInterval)
        }
    }
    
    private func flipCards() {
        guard gameState.isGameActive else {
            stopGameTimer()
            return
        }
        
        let round = gameState.playRound()
        
        if round == nil || gameState.currentRound >= gameState.maxRounds {
            stopGameTimer()
        } else {
            timeUntilNextFlip = Int(cardFlipInterval)
        }
    }
    
    func stopGameTimer() {
        gameTimer?.invalidate()
        gameTimer = nil
        countdownTimer?.invalidate()
        countdownTimer = nil
        isCountingDown = false
        timeUntilNextFlip = 0
    }
    
    func pauseGame() {
        stopGameTimer()
    }
    
    func resumeGame() {
        if gameState.isGameActive && gameState.currentRound < gameState.maxRounds {
            startGameTimer()
        }
    }
    
    func resetGame() {
        stopGameTimer()
        gameState.resetGame()
        setupAIOpponent()
    }
    
    deinit {
        stopGameTimer()
    }
} 
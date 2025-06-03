import Foundation
import CoreLocation
import Combine

class GameManager: ObservableObject {
    @Published var gameState = GameState()
    @Published var timeUntilNextFlip: Int = 5
    @Published var isCountingDown: Bool = false
    
    private var gameTimer: Timer?
    private var countdownTimer: Timer?
    private let cardFlipInterval: TimeInterval = 5.0
    private let soundManager = SoundManager.shared
    
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
        soundManager.playGameStartSound()
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
        
        // Play card flip sound
        soundManager.playCardFlipSound()
        
        let round = gameState.playRound()
        
        // Play sound based on round result for the human player
        if let round = round, let player1 = gameState.player1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                switch round.result {
                case .player1Wins:
                    self?.soundManager.playRoundResult(playerWon: true, isTie: false)
                case .player2Wins:
                    self?.soundManager.playRoundResult(playerWon: false, isTie: false)
                case .tie:
                    self?.soundManager.playRoundResult(playerWon: false, isTie: true)
                }
            }
        }
        
        if round == nil || gameState.currentRound >= gameState.maxRounds {
            stopGameTimer()
            
            // Play game end sound
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.playGameEndSound()
            }
        } else {
            timeUntilNextFlip = Int(cardFlipInterval)
        }
    }
    
    private func playGameEndSound() {
        guard let player1 = gameState.player1, let player2 = gameState.player2 else { return }
        let playerWon = player1.score > player2.score
        soundManager.playGameEndSound(playerWon: playerWon)
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
        soundManager.pauseBackgroundMusic()
    }
    
    func resumeGame() {
        if gameState.isGameActive && gameState.currentRound < gameState.maxRounds {
            startGameTimer()
            soundManager.resumeBackgroundMusic()
        }
    }
    
    func resetGame() {
        stopGameTimer()
        soundManager.stopBackgroundMusic()
        gameState.resetGame()
        setupAIOpponent()
    }
    
    deinit {
        stopGameTimer()
    }
} 

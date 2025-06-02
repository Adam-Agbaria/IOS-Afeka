//
//  GameView.swift
//  Afeka
//
//  Created by Adam Agbaria on 31/05/2025.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var gameManager: GameManager
    @State private var cardFlipAnimation: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Game Timer and Progress
                GameTimerView(gameManager: gameManager)
                
                // Score Display
                ScoreDisplayView(gameManager: gameManager)
                
                // Cards Display
                CardsDisplayView(gameManager: gameManager, cardFlipAnimation: $cardFlipAnimation)
                
                Spacer()
                
                // Game Controls
                GameControlsView(gameManager: gameManager)
            }
            .padding()
            .navigationTitle("Card Battle")
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(gameManager.$gameState) { _ in
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    cardFlipAnimation.toggle()
                }
            }
        }
    }
}

struct GameHeaderView: View {
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        VStack(spacing: 10) {
            Text("🃏 Card Battle Arena 🃏")
                .font(.title2)
                .fontWeight(.bold)
            
            if let player1 = gameManager.gameState.player1,
               let player2 = gameManager.gameState.player2 {
                HStack {
                    PlayerInfoView(player: player1)
                    
                    Spacer()
                    
                    Text("VS")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    PlayerInfoView(player: player2)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct PlayerInfoView: View {
    let player: Player
    
    var body: some View {
        VStack(spacing: 5) {
            Text(player.name)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("(\(player.side.displayName))")
                .font(.caption)
                .foregroundColor(player.side == .east ? .blue : .red)
                .fontWeight(.medium)
        }
    }
}

struct GameTimerView: View {
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Round \(gameManager.gameState.currentRound)/\(gameManager.gameState.maxRounds)")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if gameManager.isCountingDown && gameManager.gameState.isGameActive {
                    HStack(spacing: 5) {
                        Image(systemName: "timer")
                            .foregroundColor(.orange)
                        Text("Next flip: \(gameManager.timeUntilNextFlip)s")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.orange)
                    }
                }
            }
            
            // Progress bar
            ProgressView(value: Double(gameManager.gameState.currentRound), total: Double(gameManager.gameState.maxRounds))
                .progressViewStyle(LinearProgressViewStyle())
                .scaleEffect(x: 1, y: 2, anchor: .center)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct ScoreDisplayView: View {
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        HStack(spacing: 20) {
            // Player 1 Score
            if let player1 = gameManager.gameState.player1 {
                VStack(spacing: 5) {
                    Text(player1.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(player1.side == .east ? .blue : .red)
                    
                    VStack(spacing: 2) {
                        Text("Score")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(player1.score)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(player1.side == .east ? .blue : .red)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            
            Spacer()
            
            // VS Symbol with overall game info
            VStack(spacing: 5) {
                Image(systemName: "trophy.fill")
                    .font(.title2)
                    .foregroundColor(.yellow)
                
                Text("VS")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Player 2 Score
            if let player2 = gameManager.gameState.player2 {
                VStack(spacing: 5) {
                    Text(player2.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(player2.side == .east ? .blue : .red)
                    
                    VStack(spacing: 2) {
                        Text("Score")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(player2.score)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(player2.side == .east ? .blue : .red)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
        }
    }
}

struct CardsDisplayView: View {
    @ObservedObject var gameManager: GameManager
    @Binding var cardFlipAnimation: Bool
    
    var body: some View {
        HStack(spacing: 30) {
            // Player 1 Card
            VStack(spacing: 10) {
                Text(gameManager.gameState.player1?.name ?? "Player 1")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(gameManager.gameState.player1?.side == .east ? .blue : .red)
                
                CardView(card: gameManager.gameState.currentPlayer1Card)
                    .scaleEffect(cardFlipAnimation ? 1.05 : 1.0)
                    .rotation3DEffect(
                        .degrees(cardFlipAnimation ? 5 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
            }
            
            // VS Symbol
            VStack {
                Image(systemName: "bolt.fill")
                    .font(.title)
                    .foregroundColor(.yellow)
                    .scaleEffect(cardFlipAnimation ? 1.2 : 1.0)
                
                Text("VS")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            }
            
            // Player 2 Card
            VStack(spacing: 10) {
                Text(gameManager.gameState.player2?.name ?? "Player 2")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(gameManager.gameState.player2?.side == .east ? .blue : .red)
                
                CardView(card: gameManager.gameState.currentPlayer2Card)
                    .scaleEffect(cardFlipAnimation ? 1.05 : 1.0)
                    .rotation3DEffect(
                        .degrees(cardFlipAnimation ? -5 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
            }
        }
        .animation(.easeInOut(duration: 0.5), value: cardFlipAnimation)
    }
}

struct CardView: View {
    let card: Card?
    
    var body: some View {
        Group {
            if let card = card {
                VStack {
                    Image(card.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 160)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
                    
                    VStack(spacing: 2) {
                        Text(card.displayName)
                            .font(.caption)
                            .fontWeight(.semibold)
                        
                        Text("Strength: \(card.strength)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            } else {
                VStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray4))
                        .frame(width: 120, height: 160)
                        .overlay(
                            VStack {
                                Image(systemName: "questionmark")
                                    .font(.title)
                                    .foregroundColor(.white)
                                Text("Waiting")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        )
                    
                    Text("No Card")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct ScoreBoardView: View {
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        HStack {
            // Player 1 Score
            VStack {
                Text(gameManager.gameState.player1?.name ?? "Player 1")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("\(gameManager.gameState.player1?.score ?? 0)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(gameManager.gameState.player1?.side == .east ? .blue : .red)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            Spacer(minLength: 20)
            
            // Player 2 Score
            VStack {
                Text(gameManager.gameState.player2?.name ?? "Player 2")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("\(gameManager.gameState.player2?.score ?? 0)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(gameManager.gameState.player2?.side == .east ? .blue : .red)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

struct RecentRoundsView: View {
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recent Rounds")
                .font(.headline)
                .fontWeight(.semibold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(gameManager.gameState.rounds.suffix(5).reversed(), id: \.roundNumber) { round in
                        RoundResultView(round: round)
                    }
                }
                .padding(.horizontal, 5)
            }
        }
        .frame(maxHeight: 100)
    }
}

struct RoundResultView: View {
    let round: GameRound
    
    var body: some View {
        VStack(spacing: 5) {
            Text("R\(round.roundNumber)")
                .font(.caption2)
                .fontWeight(.semibold)
            
            HStack(spacing: 5) {
                Text(round.player1Card.rank.displayName)
                    .font(.caption2)
                    .foregroundColor(resultColor(for: .player1Wins))
                
                Text("vs")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text(round.player2Card.rank.displayName)
                    .font(.caption2)
                    .foregroundColor(resultColor(for: .player2Wins))
            }
            
            Image(systemName: resultIcon)
                .font(.caption)
                .foregroundColor(resultColor(for: round.result))
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    private var resultIcon: String {
        switch round.result {
        case .player1Wins: return "arrow.left"
        case .player2Wins: return "arrow.right"
        case .tie: return "equal"
        }
    }
    
    private func resultColor(for result: BattleResult) -> Color {
        switch result {
        case .player1Wins: return .blue
        case .player2Wins: return .red
        case .tie: return .orange
        }
    }
}

struct GameControlsView: View {
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        HStack(spacing: 15) {
            if gameManager.gameState.isGameActive {
                Button(action: {
                    gameManager.pauseGame()
                }) {
                    HStack {
                        Image(systemName: "pause.circle.fill")
                        Text("Pause")
                    }
                    .font(.headline)
                    .foregroundColor(.orange)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                }
            } else if gameManager.gameState.currentRound < gameManager.gameState.maxRounds && gameManager.gameState.currentRound > 0 {
                Button(action: {
                    gameManager.resumeGame()
                }) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                        Text("Resume")
                    }
                    .font(.headline)
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            
            Button(action: {
                gameManager.resetGame()
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise.circle.fill")
                    Text("New Game")
                }
                .font(.headline)
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
            }
        }
    }
}

#Preview {
    GameView(gameManager: GameManager())
} 
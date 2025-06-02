//
//  ResultsView.swift
//  Afeka
//
//  Created by Adam Agbaria on 31/05/2025.
//

import SwiftUI

struct ResultsView: View {
    @ObservedObject var gameManager: GameManager
    @State private var showDetails: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Winner Announcement
                    WinnerAnnouncementView(gameManager: gameManager)
                    
                    // Final Scores
                    FinalScoresView(gameManager: gameManager)
                    
                    // Game Statistics
                    GameStatisticsView(gameManager: gameManager)
                    
                    // Round Details Toggle
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showDetails.toggle()
                        }
                    }) {
                        HStack {
                            Text(showDetails ? "Hide Details" : "Show Round Details")
                                .font(.headline)
                            Image(systemName: showDetails ? "chevron.up" : "chevron.down")
                        }
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    // Round by Round Details
                    if showDetails {
                        RoundDetailsView(gameManager: gameManager)
                            .transition(.scale.combined(with: .opacity))
                    }
                    
                    // Action Buttons
                    ActionButtonsView(gameManager: gameManager)
                }
                .padding()
            }
            .navigationTitle("Game Results")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct WinnerAnnouncementView: View {
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        VStack(spacing: 15) {
            // Winner Icon
            Image(systemName: winnerIcon)
                .font(.system(size: 80))
                .foregroundColor(winnerColor)
                .scaleEffect(1.2)
            
            // Winner Text
            Text(winnerText)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(winnerColor)
                .multilineTextAlignment(.center)
            
            // Subtitle
            Text(winnerSubtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(winnerColor.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(winnerColor.opacity(0.3), lineWidth: 2)
                )
        )
    }
    
    private var winner: Player? {
        guard let player1 = gameManager.gameState.player1,
              let player2 = gameManager.gameState.player2 else { return nil }
        
        if player1.score > player2.score {
            return player1
        } else if player2.score > player1.score {
            return player2
        } else {
            return nil // Tie
        }
    }
    
    private var winnerIcon: String {
        if winner != nil {
            return "crown.fill"
        } else {
            return "handshake.fill"
        }
    }
    
    private var winnerColor: Color {
        if let winner = winner {
            return winner.side == .east ? .blue : .red
        } else {
            return .orange
        }
    }
    
    private var winnerText: String {
        if let winner = winner {
            return "\(winner.name) Wins!"
        } else {
            return "It's a Tie!"
        }
    }
    
    private var winnerSubtitle: String {
        if let winner = winner {
            let score1 = gameManager.gameState.player1?.score ?? 0
            let score2 = gameManager.gameState.player2?.score ?? 0
            return "Final Score: \(score1) - \(score2)"
        } else {
            return "Both players performed equally well!"
        }
    }
}

struct FinalScoresView: View {
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        HStack(spacing: 30) {
            // Player 1 Score
            PlayerScoreCard(
                player: gameManager.gameState.player1,
                isWinner: (gameManager.gameState.player1?.score ?? 0) > (gameManager.gameState.player2?.score ?? 0)
            )
            
            // VS
            VStack {
                Image(systemName: "bolt.fill")
                    .font(.title)
                    .foregroundColor(.yellow)
                Text("VS")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            }
            
            // Player 2 Score
            PlayerScoreCard(
                player: gameManager.gameState.player2,
                isWinner: (gameManager.gameState.player2?.score ?? 0) > (gameManager.gameState.player1?.score ?? 0)
            )
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
}

struct PlayerScoreCard: View {
    let player: Player?
    let isWinner: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            // Winner crown
            if isWinner {
                Image(systemName: "crown.fill")
                    .font(.title3)
                    .foregroundColor(.yellow)
            } else {
                Spacer()
                    .frame(height: 20)
            }
            
            // Player name
            Text(player?.name ?? "Unknown")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(player?.side == .east ? .blue : .red)
            
            // Side
            Text("(\(player?.side.displayName ?? "Unknown") Side)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Score
            Text("\(player?.score ?? 0)")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(isWinner ? .green : .primary)
            
            Text("Rounds Won")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(isWinner ? Color.green.opacity(0.1) : Color.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isWinner ? Color.green : Color.clear, lineWidth: 2)
        )
        .cornerRadius(12)
    }
}

struct GameStatisticsView: View {
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Game Statistics")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                StatisticCard(title: "Total Rounds", value: "\(gameManager.gameState.currentRound)", icon: "number.circle.fill")
                StatisticCard(title: "Ties", value: "\(tieCount)", icon: "equal.circle.fill")
                StatisticCard(title: "Player 1 Wins", value: "\(player1Wins)", icon: "person.circle.fill")
                StatisticCard(title: "Player 2 Wins", value: "\(player2Wins)", icon: "person.circle.fill")
            }
        }
    }
    
    private var tieCount: Int {
        gameManager.gameState.rounds.filter { $0.result == .tie }.count
    }
    
    private var player1Wins: Int {
        gameManager.gameState.rounds.filter { $0.result == .player1Wins }.count
    }
    
    private var player2Wins: Int {
        gameManager.gameState.rounds.filter { $0.result == .player2Wins }.count
    }
}

struct StatisticCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct RoundDetailsView: View {
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Round by Round Breakdown")
                .font(.headline)
                .fontWeight(.semibold)
            
            ForEach(gameManager.gameState.rounds, id: \.roundNumber) { round in
                RoundDetailCard(round: round, 
                              player1Name: gameManager.gameState.player1?.name ?? "Player 1",
                              player2Name: gameManager.gameState.player2?.name ?? "Player 2")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct RoundDetailCard: View {
    let round: GameRound
    let player1Name: String
    let player2Name: String
    
    var body: some View {
        HStack {
            // Round number
            VStack {
                Text("Round")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text("\(round.roundNumber)")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .frame(width: 50)
            
            Spacer()
            
            // Player 1 card
            VStack(spacing: 3) {
                Text(player1Name)
                    .font(.caption)
                    .fontWeight(.medium)
                Text(round.player1Card.displayName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                Text("(\(round.player1Card.strength))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            // VS and result
            VStack(spacing: 3) {
                Text("VS")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Image(systemName: resultIcon(for: round.result))
                    .font(.title3)
                    .foregroundColor(resultColor(for: round.result))
            }
            
            // Player 2 card
            VStack(spacing: 3) {
                Text(player2Name)
                    .font(.caption)
                    .fontWeight(.medium)
                Text(round.player2Card.displayName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
                Text("(\(round.player2Card.strength))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(8)
    }
    
    private func resultIcon(for result: BattleResult) -> String {
        switch result {
        case .player1Wins: return "arrow.left.circle.fill"
        case .player2Wins: return "arrow.right.circle.fill"
        case .tie: return "equal.circle.fill"
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

struct ActionButtonsView: View {
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        Button(action: {
            gameManager.resetGame()
        }) {
            HStack {
                Image(systemName: "arrow.clockwise.circle.fill")
                Text("Play Again")
            }
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
        }
    }
}

#Preview {
    ResultsView(gameManager: GameManager())
} 
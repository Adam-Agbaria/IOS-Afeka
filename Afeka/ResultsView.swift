//
//  ResultsView.swift
//  Afeka
//
//  Created by Adam Agbaria on 31/05/2025.
//

import SwiftUI

struct ResultsView: View {
    @ObservedObject var gameManager: GameManager
    @State private var showingDetails: Bool = false
    
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
                        withAnimation {
                            showingDetails.toggle()
                        }
                    }) {
                        HStack {
                            Text("Round Details")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Image(systemName: showingDetails ? "chevron.up" : "chevron.down")
                                .font(.headline)
                        }
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Round Details
                    if showingDetails {
                        RoundDetailsView(gameManager: gameManager)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    // Action Buttons
                    ActionButtonsView(gameManager: gameManager)
                }
                .padding()
            }
            .navigationTitle("Game Results")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct WinnerAnnouncementView: View {
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        VStack(spacing: 15) {
            // Trophy or Tie Icon
            Image(systemName: winnerIcon)
                .font(.system(size: 80))
                .foregroundColor(winnerColor)
                .scaleEffect(1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: UUID())
            
            // Winner Text
            Text(winnerText)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(winnerColor)
                .multilineTextAlignment(.center)
            
            // Subtitle
            Text(subtitleText)
                .font(.headline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(winnerColor.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(winnerColor.opacity(0.3), lineWidth: 2)
                )
        )
    }
    
    private var winner: Player? {
        gameManager.gameState.getWinner()
    }
    
    private var winnerIcon: String {
        if winner != nil {
            return "crown.fill"
        } else {
            return "equal.circle.fill"
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
            return "🎉 \(winner.name) Wins! 🎉"
        } else {
            return "🤝 It's a Tie! 🤝"
        }
    }
    
    private var subtitleText: String {
        if let winner = winner {
            return "\(winner.side.displayName) Side Victory"
        } else {
            return "Both players performed equally well"
        }
    }
}

struct FinalScoresView: View {
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Final Scores")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack(spacing: 20) {
                // Player 1 Score
                PlayerScoreCard(
                    player: gameManager.gameState.player1,
                    isWinner: gameManager.gameState.getWinner()?.id == gameManager.gameState.player1?.id
                )
                
                // VS
                VStack {
                    Text("VS")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                }
                
                // Player 2 Score
                PlayerScoreCard(
                    player: gameManager.gameState.player2,
                    isWinner: gameManager.gameState.getWinner()?.id == gameManager.gameState.player2?.id
                )
            }
        }
    }
}

struct PlayerScoreCard: View {
    let player: Player?
    let isWinner: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            if let player = player {
                Text(player.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(player.side == .east ? .blue : .red)
                
                Text("(\(player.side.displayName))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("\(player.score)")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(player.side == .east ? .blue : .red)
                
                if isWinner {
                    Image(systemName: "crown.fill")
                        .font(.title2)
                        .foregroundColor(.yellow)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isWinner ? Color.yellow.opacity(0.1) : Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isWinner ? Color.yellow : Color.clear, lineWidth: 2)
                )
        )
    }
}

struct GameStatisticsView: View {
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Game Statistics")
                .font(.title2)
                .fontWeight(.bold)
            
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
        VStack(spacing: 15) {
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
            
            Button(action: {
                gameManager.gameState.phase = .setup
            }) {
                HStack {
                    Image(systemName: "house.circle.fill")
                    Text("Return to Setup")
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
    ResultsView(gameManager: GameManager())
} 
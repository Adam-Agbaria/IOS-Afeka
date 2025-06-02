//
//  Card.swift
//  Afeka
//
//  Created by Adam Agbaria on 31/05/2025.
//

import Foundation
import SwiftUI

enum Suit: String, CaseIterable {
    case hearts = "hearts"
    case diamonds = "diamonds"
    case clubs = "clubs"
    case spades = "spades"
    
    var displayName: String {
        switch self {
        case .hearts: return "♥"
        case .diamonds: return "♦"
        case .clubs: return "♣"
        case .spades: return "♠"
        }
    }
    
    var color: Color {
        switch self {
        case .hearts, .diamonds: return .red
        case .clubs, .spades: return .black
        }
    }
}

enum Rank: Int, CaseIterable {
    case two = 2, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
    
    var displayName: String {
        switch self {
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .ten: return "10"
        case .jack: return "J"
        case .queen: return "Q"
        case .king: return "K"
        case .ace: return "A"
        }
    }
    
    var strength: Int {
        switch self {
        case .ace: return 14  // Ace is highest
        default: return self.rawValue
        }
    }
}

struct Card: Identifiable, Equatable {
    let id = UUID()
    let rank: Rank
    let suit: Suit
    
    var displayName: String {
        return "\(rank.displayName)\(suit.displayName)"
    }
    
    var strength: Int {
        return rank.strength
    }
    
    var imageName: String {
        let rankName: String
        switch rank {
        case .jack: rankName = "jack"
        case .queen: rankName = "queen"
        case .king: rankName = "king"
        case .ace: rankName = "ace"
        default: rankName = rank.displayName
        }
        return "\(rankName)_of_\(suit.rawValue)"
    }
    
    static func createDeck() -> [Card] {
        var deck: [Card] = []
        for suit in Suit.allCases {
            for rank in Rank.allCases {
                deck.append(Card(rank: rank, suit: suit))
            }
        }
        return deck.shuffled()
    }
} 
# Location-Based Card Flip Game

A location-based iOS card game that determines player sides based on GPS coordinates and features an automatic card flipping battle system using standard playing cards.

## 🎮 Game Overview

### Location-Based Gameplay
- Uses device GPS to determine player side (East/West of latitude 34.817549168324334)
- Requires player name and location to start
- Supports mock location data for emulators

### Card Battle Mechanics
- Automatic game start after side determination
- Two standard playing cards displayed simultaneously
- Cards flip every 5 seconds showing new cards
- Each card has a strength value based on rank (2=2, 3=3, ..., 10=10, J=11, Q=12, K=13, A=14)
- 10 rounds total
- Ties go to the "house"
- Final scoring and winner announcement

## 🃏 Playing Cards

The game uses a standard 52-card deck with traditional ranks and suits:
- **Ranks**: 2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K, A
- **Suits**: Hearts (♥), Diamonds (♦), Clubs (♣), Spades (♠)
- **Strength Values**: 2=2, 3=3, 4=4, 5=5, 6=6, 7=7, 8=8, 9=9, 10=10, J=11, Q=12, K=13, A=14
- **Card Colors**: Hearts and Diamonds are red, Clubs and Spades are black

## 🌙 Features

### Dark Mode Support
- Adaptive text colors for light/dark themes
- Traditional playing card design that works in both modes
- Full UI compatibility in both modes

### Sound System
- Background music (stops when game paused/stopped)
- Card flip sound effects
- Game end sound effects
- Victory sound effects

### Responsive Design
- Portrait and landscape orientation support
- Proper screen stack navigation
- Lifecycle management for app pause/resume

## 🛠️ Technical Requirements

- iOS 14.0+
- Swift 5.0+
- Core Location framework
- AVFoundation for audio
- UIKit for interface

## 📱 Installation

1. Clone the repository
2. Open `CardFlipGame.xcodeproj` in Xcode
3. Build and run on device or simulator
4. Grant location permissions when prompted

## 🎯 Game Flow

1. **Launch** → Request location permissions
2. **Location Check** → Determine East/West side
3. **Player Setup** → Enter name and confirm location
4. **Game Start** → Automatic card battle begins
5. **Battle Rounds** → 10 rounds of card flipping
6. **Results** → Final score and winner announcement

## 📸 Demo

[Video Demo Link - To be added]

## 🏗️ Project Structure

```
CardFlipGame/
├── Models/
│   ├── Player.swift
│   ├── Card.swift (Standard playing cards)
│   └── GameState.swift
├── Views/
│   ├── ContentView.swift
│   ├── LocationSetupView.swift
│   ├── GameView.swift
│   └── ResultsView.swift
├── ViewModels/
│   ├── LocationManager.swift
│   ├── GameManager.swift
│   └── AudioManager.swift
├── Resources/
│   ├── Assets.xcassets
│   └── Sounds/
└── Supporting Files/
    ├── Info.plist
    └── CardFlipGameApp.swift
```

## 🎵 Audio Assets

- `background_music.mp3` - Main game background music
- `card_flip.wav` - Card flip sound effect
- `game_end.wav` - Game completion sound
- `victory.wav` - Victory celebration sound

## 🃏 Card System

Standard 52-card deck with:
- **4 Suits**: Hearts, Diamonds, Clubs, Spades
- **13 Ranks per suit**: 2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K, A
- **Strength-based battles**: Higher rank wins (Ace is highest)
- **Traditional card design**: White background with suit colors

## 📋 Development Notes

- Clean, commented code following Swift best practices
- Proper memory management and lifecycle handling
- Error handling for location services
- Accessibility support
- Unit tests for game logic
- Standard playing card implementation

## 🚀 Future Enhancements

- Multiplayer support
- Different card game variations (Poker, Blackjack rules)
- Custom card themes
- Leaderboard system
- Tournament mode

---

**Developed for iOS-Afeka Course Project** 
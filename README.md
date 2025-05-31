# Location-Based Card Flip Game - Afeka iOS Project

A location-based iOS card game that determines player sides based on GPS coordinates and features an automatic card flipping battle system using standard playing cards.

## 🎮 Game Overview

### Location-Based Gameplay
- Uses device GPS to determine player side (East/West of latitude 34.817549168324334)
- Requires player name and location to start
- Supports mock location data for emulators and testing

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

### Responsive Design
- Portrait and landscape orientation support
- Proper screen stack navigation
- Lifecycle management for app pause/resume

## 🛠️ Technical Requirements

- iOS 14.0+
- Swift 5.0+
- Core Location framework
- SwiftUI for interface

## 📱 Installation & Setup

1. Open `Afeka.xcodeproj` in Xcode
2. Ensure iOS deployment target is 14.0 or higher
3. Build and run on device or simulator
4. Grant location permissions when prompted

### Location Permissions
The app requires location permissions to determine player sides. These are configured in `Info.plist`:
- `NSLocationWhenInUseUsageDescription`
- `NSLocationAlwaysAndWhenInUseUsageDescription`

## 🎯 Game Flow

1. **Launch** → Request location permissions
2. **Location Check** → Determine East/West side based on GPS
3. **Player Setup** → Enter name and confirm location
4. **Game Start** → Automatic card battle begins
5. **Battle Rounds** → 10 rounds of card flipping every 5 seconds
6. **Results** → Final score and winner announcement

## 🏗️ Project Structure

```
Afeka/
├── Models/
│   ├── Player.swift               # Player data model with side determination
│   ├── Card.swift                 # Standard playing cards implementation
│   └── GameState.swift           # Game state management
├── ViewModels/
│   ├── LocationManager.swift     # GPS location handling
│   └── GameManager.swift         # Game logic and timing
├── Views/
│   ├── ContentView.swift         # Main navigation controller
│   ├── LocationSetupView.swift   # Player setup and location detection
│   ├── GameView.swift           # Main game interface with card display
│   └── ResultsView.swift        # Game results and statistics
├── Resources/
│   ├── Assets.xcassets/
│   │   └── Cards/              # Complete set of playing card images
│   └── Info.plist             # App configuration with location permissions
└── Supporting Files/
    └── CardFlipGameApp.swift    # App entry point
```

## 🃏 Card Assets

The game includes a complete set of standard playing card images located in `Assets.xcassets/Cards/`:
- All 52 standard playing cards
- High-quality PNG images
- Traditional card design with white background
- Optimized for both light and dark modes

### Card Naming Convention
Cards are named using the pattern: `{rank}_of_{suit}.png`
- Examples: `ace_of_spades.png`, `king_of_hearts.png`, `2_of_clubs.png`

## 🎮 Game Features

### Location-Based Side Assignment
- **East Side**: Latitude ≥ 34.817549168324334 (Afeka reference point)
- **West Side**: Latitude < 34.817549168324334
- Color coding: East = Blue, West = Red

### Automatic Card Battle System
- 5-second intervals between card flips
- Visual countdown timer
- Automatic score tracking
- Round-by-round history

### Rich UI Experience
- Smooth card flip animations
- Real-time score updates
- Progress indicators
- Detailed game statistics
- Comprehensive results view

## 🧪 Testing & Debug Features

### Mock Location Support
In debug builds, the app includes mock location options for testing:
- Afeka College (East side)
- Tel Aviv Center (West side)
- Custom coordinates for different scenarios

### Game Controls
- Pause/Resume functionality
- Game reset options
- Return to setup screen

## 📊 Game Statistics

The results view provides comprehensive statistics:
- Final scores for both players
- Winner announcement with visual effects
- Round-by-round breakdown
- Tie count and individual round wins
- Interactive details toggle

## 🔧 Development Notes

- Clean, commented code following Swift best practices
- Proper memory management and lifecycle handling
- Error handling for location services
- Accessibility support considerations
- SwiftUI state management with ObservableObject
- Responsive design for different screen sizes

## 🎓 Academic Context

This project was developed for the iOS Development course at Afeka College of Engineering.

### Key Learning Objectives Demonstrated:
- iOS app architecture with SwiftUI
- Core Location framework integration
- State management in iOS apps
- User interface design and animation
- App lifecycle management
- Error handling and user experience

## 🚀 Future Enhancement Ideas

- Multiplayer network support
- Different card game variations (Poker rules, etc.)
- Custom card themes and designs
- Leaderboard system
- Tournament mode
- Sound effects and background music
- Achievement system

---

**Developed for iOS-Afeka Course Project**
**Author**: Adam Agbaria
**Date**: May 2025 
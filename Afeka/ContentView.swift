import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var gameManager = GameManager()
    
    var body: some View {
        Group {
            switch gameManager.gameState.phase {
            case .setup, .locationSetup:
                LocationSetupView(locationManager: locationManager, gameManager: gameManager)
            case .playing:
                GameView(gameManager: gameManager)
            case .results:
                ResultsView(gameManager: gameManager)
            }
        }
        .preferredColorScheme(nil) // Supports both light and dark mode
    }
}

#Preview {
    ContentView()
}

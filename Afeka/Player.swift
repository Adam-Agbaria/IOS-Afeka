import Foundation
import CoreLocation

enum PlayerSide: String, CaseIterable {
    case east = "East"
    case west = "West"
    
    var displayName: String {
        return rawValue
    }
    
    var color: String {
        switch self {
        case .east: return "blue"
        case .west: return "red"
        }
    }
}

struct Player: Identifiable {
    let id = UUID()
    var name: String
    var side: PlayerSide
    var score: Int = 0
    var location: CLLocationCoordinate2D?
    
    init(name: String, side: PlayerSide, location: CLLocationCoordinate2D? = nil) {
        self.name = name
        self.side = side
        self.location = location
    }
    
    mutating func incrementScore() {
        score += 1
    }
    
    static func determineSide(from coordinate: CLLocationCoordinate2D) -> PlayerSide {
        // Based on Afeka coordinates: latitude 34.817549168324334
        let afekaLatitude = 34.817549168324334
        return coordinate.latitude >= afekaLatitude ? .east : .west
    }
} 

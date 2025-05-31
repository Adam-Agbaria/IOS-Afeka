//
//  LocationSetupView.swift
//  Afeka
//
//  Created by Adam Agbaria on 31/05/2025.
//

import SwiftUI
import CoreLocation

struct LocationSetupView: View {
    @ObservedObject var locationManager: LocationManager
    @ObservedObject var gameManager: GameManager
    @State private var playerName: String = ""
    @State private var showMockLocationOptions: Bool = false
    @State private var selectedMockLocation: String = "Afeka College (East)"
    
    // Mock location options for testing
    private let mockLocations = [
        ("Afeka College (East)", CLLocationCoordinate2D(latitude: 32.113, longitude: 34.818)),
        ("Tel Aviv Center (West)", CLLocationCoordinate2D(latitude: 32.080, longitude: 34.780)),
        ("North Location (East)", CLLocationCoordinate2D(latitude: 32.820, longitude: 34.820)),
        ("South Location (West)", CLLocationCoordinate2D(latitude: 32.810, longitude: 34.810))
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 10) {
                    Image(systemName: "location.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Location-Based Card Game")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Enter your name and detect your location to determine your side")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                
                // Player Name Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Player Name")
                        .font(.headline)
                    
                    TextField("Enter your name", text: $playerName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                }
                .padding(.horizontal)
                
                // Location Section
                VStack(spacing: 15) {
                    if let location = locationManager.location {
                        LocationInfoView(location: location)
                    } else {
                        LocationRequestView(locationManager: locationManager)
                    }
                    
                    // Mock Location Toggle (for testing)
                    #if DEBUG
                    VStack {
                        Button("Use Mock Location (Debug)") {
                            showMockLocationOptions.toggle()
                        }
                        .foregroundColor(.orange)
                        
                        if showMockLocationOptions {
                            MockLocationPicker(
                                selectedLocation: $selectedMockLocation,
                                mockLocations: mockLocations,
                                locationManager: locationManager
                            )
                        }
                    }
                    #endif
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Start Game Button
                Button(action: startGame) {
                    Text("Start Game")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(canStartGame ? Color.blue : Color.gray)
                        .cornerRadius(12)
                }
                .disabled(!canStartGame)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle("Setup")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var canStartGame: Bool {
        !playerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        locationManager.location != nil
    }
    
    private func startGame() {
        guard let location = locationManager.location else { return }
        
        let playerSide = Player.determineSide(from: location)
        gameManager.setupPlayer(name: playerName.trimmingCharacters(in: .whitespacesAndNewlines), 
                               side: playerSide, 
                               location: location)
        gameManager.startGame()
    }
}

struct LocationInfoView: View {
    let location: CLLocationCoordinate2D
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.green)
                Text("Location Detected")
                    .font(.headline)
                    .foregroundColor(.green)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Coordinates:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("Lat: \(location.latitude, specifier: "%.6f")")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Lng: \(location.longitude, specifier: "%.6f")")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                let playerSide = Player.determineSide(from: location)
                HStack {
                    Text("Your Side:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(playerSide.displayName)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(playerSide == .east ? .blue : .red)
                }
                .padding(.top, 5)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct LocationRequestView: View {
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        VStack(spacing: 15) {
            if let error = locationManager.locationError {
                VStack(spacing: 10) {
                    Image(systemName: "location.slash")
                        .font(.system(size: 40))
                        .foregroundColor(.red)
                    
                    Text("Location Error")
                        .font(.headline)
                        .foregroundColor(.red)
                    
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            
            Button(action: {
                locationManager.requestLocationPermission()
            }) {
                HStack {
                    if locationManager.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                            .foregroundColor(.white)
                        Text("Detecting Location...")
                    } else {
                        Image(systemName: "location.circle")
                        Text("Detect Location")
                    }
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(locationManager.isLoading ? Color.gray : Color.blue)
                .cornerRadius(12)
            }
            .disabled(locationManager.isLoading)
            
            // Status indicator
            if locationManager.isLoading {
                HStack {
                    ProgressView()
                        .scaleEffect(0.7)
                    Text("Requesting location permission and GPS coordinates...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }
        }
    }
}

struct MockLocationPicker: View {
    @Binding var selectedLocation: String
    let mockLocations: [(String, CLLocationCoordinate2D)]
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Mock Locations")
                .font(.headline)
            
            Picker("Mock Location", selection: $selectedLocation) {
                ForEach(mockLocations, id: \.0) { location in
                    Text(location.0).tag(location.0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Button("Apply Mock Location") {
                if let selectedLoc = mockLocations.first(where: { $0.0 == selectedLocation }) {
                    locationManager.setMockLocation(
                        latitude: selectedLoc.1.latitude,
                        longitude: selectedLoc.1.longitude
                    )
                }
            }
            .font(.caption)
            .foregroundColor(.orange)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    LocationSetupView(locationManager: LocationManager(), gameManager: GameManager())
} 
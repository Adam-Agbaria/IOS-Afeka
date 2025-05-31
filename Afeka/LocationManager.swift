//
//  LocationManager.swift
//  Afeka
//
//  Created by Adam Agbaria on 31/05/2025.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var locationError: String?
    @Published var isLocationServiceEnabled: Bool = false
    @Published var isLoading: Bool = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // Only update if moved 10 meters
        checkLocationServiceEnabled()
        authorizationStatus = locationManager.authorizationStatus
    }
    
    func checkLocationServiceEnabled() {
        DispatchQueue.main.async {
            self.isLocationServiceEnabled = CLLocationManager.locationServicesEnabled()
        }
    }
    
    func requestLocationPermission() {
        guard isLocationServiceEnabled else {
            DispatchQueue.main.async {
                self.locationError = "Location services are disabled. Please enable them in Settings."
            }
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.locationError = nil
        }
        
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.locationError = "Location access denied. Please enable location access in Settings."
                self.isLoading = false
            }
        case .authorizedWhenInUse, .authorizedAlways:
            requestLocation()
        @unknown default:
            DispatchQueue.main.async {
                self.locationError = "Unknown location authorization status."
                self.isLoading = false
            }
        }
    }
    
    private func requestLocation() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            DispatchQueue.main.async {
                self.locationError = "Location permission not granted."
                self.isLoading = false
            }
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.locationError = nil
        }
        
        // Use async location request to avoid blocking main thread
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.locationManager.requestLocation()
            }
        }
    }
    
    func determineSide() -> PlayerSide? {
        guard let location = location else { return nil }
        return Player.determineSide(from: location)
    }
    
    // Mock location for testing/emulator
    func setMockLocation(latitude: Double, longitude: Double) {
        DispatchQueue.main.async {
            self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.locationError = nil
            self.isLoading = false
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            guard let location = locations.last else { return }
            self.location = location.coordinate
            self.locationError = nil
            self.isLoading = false
            print("Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.locationError = "Failed to get location: \(error.localizedDescription)"
            self.isLoading = false
            print("Location error: \(error.localizedDescription)")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus
            print("Authorization changed to: \(self.authorizationStatus.rawValue)")
            
            switch self.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                print("Location authorized, requesting location...")
                self.requestLocation()
            case .denied, .restricted:
                self.locationError = "Location access denied. Please enable location access in Settings."
                self.isLoading = false
            case .notDetermined:
                print("Location authorization not determined")
                self.isLoading = false
            @unknown default:
                self.locationError = "Unknown location authorization status."
                self.isLoading = false
            }
        }
    }
} 
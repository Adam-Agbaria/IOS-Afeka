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
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkLocationServiceEnabled()
    }
    
    func checkLocationServiceEnabled() {
        isLocationServiceEnabled = CLLocationManager.locationServicesEnabled()
    }
    
    func requestLocationPermission() {
        guard isLocationServiceEnabled else {
            locationError = "Location services are disabled. Please enable them in Settings."
            return
        }
        
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            locationError = "Location access denied. Please enable in Settings."
        case .authorizedWhenInUse, .authorizedAlways:
            requestLocation()
        @unknown default:
            locationError = "Unknown location authorization status."
        }
    }
    
    func requestLocation() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            locationError = "Location permission not granted."
            return
        }
        
        locationManager.requestLocation()
    }
    
    func determineSide() -> PlayerSide? {
        guard let location = location else { return nil }
        return Player.determineSide(from: location)
    }
    
    // Mock location for testing/emulator
    func setMockLocation(latitude: Double, longitude: Double) {
        location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        locationError = nil
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location.coordinate
        locationError = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = "Failed to get location: \(error.localizedDescription)"
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            requestLocation()
        case .denied, .restricted:
            locationError = "Location access denied. Please enable in Settings."
        case .notDetermined:
            break
        @unknown default:
            locationError = "Unknown location authorization status."
        }
    }
} 
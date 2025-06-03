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
    
    private var hasPendingLocationRequest: Bool = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // Only update if moved 10 meters
        
        // Initialize state
        isLocationServiceEnabled = CLLocationManager.locationServicesEnabled()
        authorizationStatus = locationManager.authorizationStatus
    }
    
    func requestLocationPermission() {
        print("🗺️ requestLocationPermission called")
        
        guard isLocationServiceEnabled else {
            print("❌ Location services are disabled")
            DispatchQueue.main.async {
                self.locationError = "Location services are disabled. Please enable them in Settings."
                self.isLoading = false
            }
            return
        }
        
        print("🗺️ Current authorization status: \(authorizationStatus.rawValue)")
        
        // Clear any previous errors
        locationError = nil
        isLoading = true
        hasPendingLocationRequest = true
        
        switch authorizationStatus {
        case .notDetermined:
            print("🗺️ Requesting authorization...")
            locationManager.requestWhenInUseAuthorization()
            
        case .denied, .restricted:
            print("❌ Location access denied/restricted")
            DispatchQueue.main.async {
                self.locationError = "Location access denied. Please enable location access in Settings."
                self.isLoading = false
                self.hasPendingLocationRequest = false
            }
            
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅ Already authorized, requesting location...")
            requestCurrentLocation()
            
        @unknown default:
            print("❓ Unknown authorization status")
            DispatchQueue.main.async {
                self.locationError = "Unknown location authorization status."
                self.isLoading = false
                self.hasPendingLocationRequest = false
            }
        }
    }
    
    private func requestCurrentLocation() {
        print("🗺️ requestCurrentLocation called")
        
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            print("❌ Not authorized for location")
            DispatchQueue.main.async {
                self.locationError = "Location permission not granted."
                self.isLoading = false
                self.hasPendingLocationRequest = false
            }
            return
        }
        
        print("🗺️ Requesting location from CLLocationManager...")
        locationManager.requestLocation()
    }
    
    func determineSide() -> PlayerSide? {
        guard let location = location else { return nil }
        return Player.determineSide(from: location)
    }
    
    // Mock location for testing/emulator
    func setMockLocation(latitude: Double, longitude: Double) {
        print("🗺️ Setting mock location: \(latitude), \(longitude)")
        DispatchQueue.main.async {
            self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.locationError = nil
            self.isLoading = false
            self.hasPendingLocationRequest = false
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("🗺️ Did update locations: \(locations)")
        
        DispatchQueue.main.async {
            guard let location = locations.last else { 
                print("❌ No location in update")
                return 
            }
            
            print("✅ Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            self.location = location.coordinate
            self.locationError = nil
            self.isLoading = false
            self.hasPendingLocationRequest = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Location error: \(error.localizedDescription)")
        
        DispatchQueue.main.async {
            self.locationError = "Failed to get location: \(error.localizedDescription)"
            self.isLoading = false
            self.hasPendingLocationRequest = false
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let newStatus = manager.authorizationStatus
        print("🗺️ Authorization changed from \(authorizationStatus.rawValue) to \(newStatus.rawValue)")
        
        DispatchQueue.main.async {
            self.authorizationStatus = newStatus
            
            switch newStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                print("✅ Location authorized")
                // Only request location if we have a pending request
                if self.hasPendingLocationRequest {
                    self.requestCurrentLocation()
                }
                
            case .denied, .restricted:
                print("❌ Location denied/restricted")
                self.locationError = "Location access denied. Please enable location access in Settings."
                self.isLoading = false
                self.hasPendingLocationRequest = false
                
            case .notDetermined:
                print("❓ Location authorization still not determined")
                // Keep waiting, don't reset loading state yet
                
            @unknown default:
                print("❓ Unknown authorization status: \(newStatus.rawValue)")
                self.locationError = "Unknown location authorization status."
                self.isLoading = false
                self.hasPendingLocationRequest = false
            }
        }
    }
} 

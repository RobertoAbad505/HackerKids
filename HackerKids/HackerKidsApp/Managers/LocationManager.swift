//
//  LocationManager.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 4/25/25.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var pinLocation: LocationPin? = nil
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var permissionDenied: Bool = false

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.allowsBackgroundLocationUpdates = false
    }
    func askForpermission() {
        print("Asking for location permission . . .")
        manager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        print("Testing location; authorization: \(authorizationStatus)")
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅location permission granted; authorization: \(authorizationStatus)")
            return
        case .denied, .restricted:
            permissionDenied = true
            print("❌Location permission denied; authorization: \(authorizationStatus)")
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        pinLocation = LocationPin(coordinate: location!.coordinate)
        print("🌐Localizacion obtenida: \(location!.coordinate)")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌Failed to find user's location: \(error.localizedDescription)")
    }
    func requestLocation() {
        print("📍 Requesting location update...")
        manager.requestLocation()
    }
}
struct LocationPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

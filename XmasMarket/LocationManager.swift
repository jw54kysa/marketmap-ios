//
//  LocationManager.swift
//  XmasMarket
//
//  Created by Private Jon  on 08.10.25.
//
import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.first else { return }
        DispatchQueue.main.async {
            self.userLocation = latest.coordinate
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("Berechtigung noch nicht bestimmt")
        case .restricted, .denied:
            print("Zugriff verweigert")
        case .authorizedWhenInUse, .authorizedAlways:
            print("Zugriff erlaubt")
        @unknown default:
            break
        }
    }
}

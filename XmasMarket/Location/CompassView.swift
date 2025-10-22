//
//  CompassView.swift
//  XmasMarket
//
//  Created by Private Jon  on 09.10.25.
//

import CoreLocation
import Combine
import SwiftUI

struct CompassView: View {
    @ObservedObject var locationManager: LocationManager
    @StateObject private var headingManager = HeadingManager()
    
    var destination: CLLocationCoordinate2D

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(lineWidth: 2)
                    .foregroundColor(.accent)
                    .frame(width: 150, height: 150)
                
                Image(systemName: "location.north.line.fill")
                    .resizable()
                    .frame(width: 50, height: 75)
                    .foregroundColor(.accent)
                    .shadow(radius: 5)
                    .rotationEffect(.degrees(needleRotationAngle()))
            }

            if let userLoc = locationManager.userLocation {
                let dist = distance(from: userLoc, to: destination)
                    Text("Noch \(formatDistance(dist))")
                    .font(.headline)
                    .foregroundStyle(.accent)
            } else {
                Text("Getting location...")
                    .foregroundStyle(.accent)
            }
        }
        .onAppear {
            locationManager.startUpdating()
        }
    }

    private func bearing(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDirection {
        let lat1 = from.latitude.toRadians()
        let lon1 = from.longitude.toRadians()
        let lat2 = to.latitude.toRadians()
        let lon2 = to.longitude.toRadians()
        
        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        var bearing = radiansBearing.toDegrees()
        bearing = (bearing + 360).truncatingRemainder(dividingBy: 360)
        return bearing
    }
    
    private func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLocation.distance(from: toLocation) // in meters
    }
    
    private func formatDistance(_ distance: CLLocationDistance) -> String {
        if distance > 1000 {
            return String(format: "%.2f km", distance / 1000)
        } else {
            return String(format: "%.0f m", distance)
        }
    }


    private func needleRotationAngle() -> Double {
        guard let userLoc = locationManager.userLocation else { return 0 }
        let bearingToTarget = bearing(from: userLoc, to: destination)
        return bearingToTarget - headingManager.heading
    }
}

private extension Double {
    func toRadians() -> Double { self * .pi / 180 }
    func toDegrees() -> Double { self * 180 / .pi }
}


#Preview {
    CompassView(locationManager: LocationManager(), destination: CLLocationCoordinate2D(latitude: 51.3208980035929, longitude: 12.362951554210621))
}

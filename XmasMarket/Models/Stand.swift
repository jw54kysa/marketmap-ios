//
//  Stand.swift
//  XmasMarket
//
//  Created by Private Jon  on 08.10.25.
//

import Foundation
import CoreLocation

struct Stand: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let icon: String
    let type: String
    let info: String
    let open_time: String
    let close_time: String
    let lat: Double
    let lng: Double
    
    var coordinate: CLLocationCoordinate2D {
         CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
    
    var boothType: BoothType {
        BoothType(rawValue: type)
    }
}

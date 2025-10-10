//
//  Stand.swift
//  XmasMarket
//
//  Created by Private Jon  on 08.10.25.
//

import Foundation
import CoreLocation

struct Offer: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let price: Double
}

struct Stand: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let icon: String?
    let type: String?
    let info: String?
    let offers: [Offer]
    let open_time: String?
    let close_time: String?
    let lat: Double?
    let lng: Double?
    
    var coordinate: CLLocationCoordinate2D {
        guard let lat, let lng else {
            return .init(latitude: 0, longitude: 0)
        }
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
    
    var boothType: BoothType {
        guard let type else {
            return .unknown
        }
        return BoothType(rawValue: type)
    }
}

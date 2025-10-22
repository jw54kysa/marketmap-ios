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
    let city: String?
    let event: String?
    let section: String?
    let name: String
    let icon: String?
    let type: String?
    let info: String?
    let offers: [Offer]
    let open_time: String?
    let close_time: String?
    let lat: Double?
    let lng: Double?
    let image: String?
    let rating: Double?
    
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
    
    var imageURL: URL? {
        guard let image else {
            return nil
        }
        return URL(string: "\(domain)/images/\(image)")
    }
}

let defaultStand = Stand(
    id: 0,
    city: "Leipzig",
    event: "wm",
    section: "1",
    name: "Default Leipzig Stand",
    icon: "🍷",
    type: "wine",
    info: "This is a default stand located in the middle of Leipzig.",
    offers: [Offer(id: 0, name: "Wein", price: 5.5), Offer(id: 1, name: "Rotwein", price: 6.5)],
    open_time: "12:00",
    close_time: "22:00",
    lat: 51.3397,  // Leipzig latitude
    lng: 12.3731,   // Leipzig longitude
    image: "gluwein.jpg",
    rating: 2.5
)

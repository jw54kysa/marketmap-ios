//
//  BoothType.swift
//  XmasMarket
//
//  Created by Private Jon  on 08.10.25.
//
import SwiftUI

enum BoothType: String, CaseIterable, Identifiable {
    case wine
    case food
    case wool
    case wood
    case entertainment
    case unknown
    
    var id: String { self.rawValue }
    
    init(rawValue: String) {
        switch rawValue.lowercased() {
        case "wine": self = .wine
        case "food": self = .food
        case "wool": self = .wool
        case "wood": self = .wood
        case "entertainment": self = .entertainment
        default: self = .unknown
        }
    }
    
    var displayName: String {
        switch self {
        case .wine: return "Wein"
        case .food: return "Essen"
        case .wool: return "Wolle"
        case .wood: return "Holz"
        case .entertainment: return "Unterhaltung"
        case .unknown: return "Unbekannt"
        }
    }
    
    var icon: String {
        switch self {
        case .wine: return "🍷"
        case .food: return "🥙"
        case .wool: return "🐏"
        case .wood: return "🪵"
        case .entertainment: return "🎡"
        case .unknown: return "❓"
        }
    }
    
    var color: Color {
        switch self {
        case .wine: return .red
        case .food: return .orange
        case .wool: return .white
        case .wood: return .brown
        case .entertainment: return .purple
        case .unknown: return .gray
        }
    }
    
    static var allCasesBut: [BoothType] {
            return Self.allCases.filter { $0 != .unknown }
        }
}

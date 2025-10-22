//
//  InitPopup.swift
//  XmasMarket
//
//  Created by Private Jon  on 20.10.25.
//
import SwiftUI

let availableMarkets: [String: String] = [
    "25_lpz_wm": "🎅🏼 Leipziger Weihnachtsmarkt"
]

struct InitPopup: View {
    @Environment(\.dismiss) private var dismiss
    
    var markets: [String]
    var filteresMarkets: [String] {
        return markets.filter { market in
            availableMarkets.keys.contains(market)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteresMarkets, id: \.self) { market in
                    Text(availableMarkets[market]!)
                        .onTapGesture {
                            InitManager.shared.selectedMarket = market
                            NotificationCenter.default.post(name: .selectedMarket, object: nil)
                            dismiss()
                        }
                }
            }
            .navigationTitle("Marktauswahl")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        InitManager.shared.sendDeviceActivation()
                    }) {
                        Image(systemName: "arrow.trianglehead.counterclockwise")
                    }
                }
            }
        }
    }
}

#Preview {
    InitPopup(markets: ["25_lpz_wm"])
}

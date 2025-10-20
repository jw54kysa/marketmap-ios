//
//  ContentView.swift
//  XmasMarket
//
//  Created by Private Jon  on 26.09.25.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var initManager = InitManager.shared
    @State private var showPopup = false
    
    var body: some View {
        MapView()
            .onAppear() {
                initManager.sendDeviceActivation()
            }
            .onChange(of: initManager.availableMarkets) {
                if initManager.selectedMarket == nil, initManager.availableMarkets?.isEmpty == false {
                    showPopup.toggle()
                }
            }
            .sheet(isPresented: $showPopup) {
                InitPopup(markets: initManager.availableMarkets ?? [])
                    .presentationDetents([.medium])
            }
            .onReceive(NotificationCenter.default.publisher(for: .selectedMarketNil)) { _ in
                showPopup.toggle()
            }
    }
}


#Preview {
    ContentView()
}

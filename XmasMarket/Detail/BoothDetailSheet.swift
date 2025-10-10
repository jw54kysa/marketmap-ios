//
//  BoothDetailSheet.swift
//  XmasMarket
//
//  Created by Private Jon on 29.09.25.
//


import SwiftUI
import MapKit

struct BoothDetailSheet: View {
    let stand: Stand
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Booth Image
                    Image(stand.boothType == .entertainment ? .buehne : .booth)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(12)
                    
                    Divider()
                    
                    // Extra info (example)
                    VStack(alignment: .leading, spacing: 8) {
                        
                        if let info = stand.info, !info.isEmpty {
                            Text(info)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                    
                    CompassView(locationManager: LocationManager(),
                                destination: stand.coordinate)
                }
                .padding()
            }
            .navigationTitle(stand.boothType.icon + stand.name)
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "arrow.trianglehead.counterclockwise")
                    }
                }
            }
        }
    }
}

#Preview {
    BoothDetailSheet(stand: StandManager().stands.first!)
}

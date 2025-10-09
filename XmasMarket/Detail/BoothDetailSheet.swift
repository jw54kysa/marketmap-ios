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
        ScrollView {
            VStack(spacing: 16) {
                // Booth Image
                Image(stand.boothType == .entertainment ? .buehne : .booth)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(12)
                
                // Booth Title + Icon
                HStack(spacing: 12) {
                    Text(stand.icon)
                        .font(.largeTitle)
                    VStack(alignment: .leading) {
                        Text(stand.name)
                            .font(.title2)
                            .bold()
                        Text(stand.boothType.displayName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                
                Divider()
                
                // Extra info (example)
                VStack(alignment: .leading, spacing: 8) {
                    
                    if !stand.info.isEmpty {
                        Text(stand.info)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Infos ..
                    Text("Mehr Infos ...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .padding()
        }
    }
}

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
                    if let imageURL = stand.imageURL {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(height: 200)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: 200)
                                    .clipped()
                                    .cornerRadius(12)
                            case .failure:
                                Image(.booth)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: 200)
                                    .clipped()
                                    .cornerRadius(12)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                    
                    // Extra info
                    VStack(alignment: .leading, spacing: 8) {
                        if let openingHours = stand.open_time, let closingHours = stand.close_time {
                            Text("Öffnungszeiten: \(openingHours) - \(closingHours)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        if let info = stand.info, !info.isEmpty {
                            Text(info)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(3)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                    
                    // Angebot
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Angebot")
                            .font(.headline)
                        if !stand.offers.isEmpty {
                            ForEach(stand.offers.prefix(5)) { offer in
                                Text(" - \(offer.name): \(offer.price, specifier: "%.2f€")")
                            }
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
            //            .toolbar {
            //                ToolbarItem {
            //                    Button(action: {
            //
            //                    }) {
            //                        Image(systemName: "arrow.trianglehead.counterclockwise")
            //                    }
            //                }
            //            }
        }
    }
}

#Preview {
    BoothDetailSheet(stand: defaultStand)
}

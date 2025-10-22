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
                        HStack {
                            Text(stand.boothType.icon + " " + stand.boothType.displayName)
                                .font(.custom("Modak", size: 30, relativeTo: .title))
                            
                            Spacer()
                            
                            HStack(alignment: .top) {
                                if let rating = stand.rating {
                                    Text(String(format: "%.1f", rating))
                                        .font(.custom("Modak", size: 30, relativeTo: .title))
                                } else {
                                    Text("-")
                                        .font(.custom("Modak", size: 30, relativeTo: .title))
                                }
                                
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30)
                                    .foregroundStyle(.yellow)
                                    .padding(.top, 2)
                                
                            }
                        }
                        
                        if let openingHours = stand.open_time, let closingHours = stand.close_time {
                            Text("Offen von \(openingHours) - \(closingHours) Uhr")
                                .font(.headline)
                                .lineLimit(1)
                        }
                        
                        if let info = stand.info, !info.isEmpty {
                            Text(info)
                                .font(.headline)
                                .lineLimit(8)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                    
                    // Angebot
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Angebot")
                            .font(.custom("Modak", size: 30, relativeTo: .title))
                        if !stand.offers.isEmpty {
                            ForEach(stand.offers.prefix(5)) { offer in
                                Text(" - \(offer.name): \(offer.price, specifier: "%.2f €")")
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: -10) {
                        Text("Bewertung")
                            .font(.custom("Modak", size: 30, relativeTo: .title))
                        Text("Gib jetzt eine Bewertung für den Stand ab.")
                            .font(.headline)
                            .lineLimit(2)
                        HStack {
                            Spacer()
                            StarRatingView(
                                deviceUUID: UserDefaults.standard.string(forKey: "deviceID"),
                                standID: stand.id
                            )
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                    
                    
                    VStack(alignment: .leading, spacing: -10) {
                        Text("Richtung")
                            .font(.custom("Modak", size: 30, relativeTo: .title))
                        HStack {
                            Spacer()
                            CompassView(locationManager: LocationManager(),
                                        destination: stand.coordinate)
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .padding()
            }
            .navigationTitle(stand.name)
        }
    }
}

#Preview {
    BoothDetailSheet(stand: defaultStand)
}

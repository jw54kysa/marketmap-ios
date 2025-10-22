//
//  StarRatingView.swift
//  XmasMarket
//
//  Created by Private Jon  on 20.10.25.
//


import SwiftUI

struct StarRatingView: View {
    @ObservedObject var ratingManager: RatingManager
    let maxRating = 5
    
    var deviceUUID: String?
    var standID: Int
    
    var body: some View {
        
        VStack(spacing: 10) {
            HStack {
                ForEach(1...maxRating, id: \.self) { index in
                    Image(systemName: index <= ratingManager.currentRating ?? 0 ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.yellow)
                        .onTapGesture {
                            ratingManager.currentRating = index
                            submitRating()
                        }
                }
            }
            
            if ratingManager.isSubmitting {
                ProgressView()
            }
            
            if let success = ratingManager.successMessage {
                Text(success)
                    .foregroundColor(.green)
                    .font(.subheadline)
            }
            
            if let error = ratingManager.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.subheadline)
            }
        }
        .padding()
        .onAppear {
            guard let deviceUUID else { return }
            ratingManager.getRating(for: deviceUUID, standID: standID)
        }
    }
    
    private func submitRating() {
        guard let deviceUUID else { return }
        ratingManager.submitRating(deviceUUID: deviceUUID, standID: standID)
    }
}

struct DeviceStandRatingResponse: Codable {
    let device_uuid: String
    let stand_id: Int
    let rating: Int?
}

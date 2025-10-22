//
//  RatingManager.swift
//  XmasMarket
//
//  Created by Private Jon  on 20.10.25.
//
import SwiftUI
import Combine

class RatingManager: ObservableObject {
    @Published var isSubmitting: Bool = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var currentRating: Int?
    
    private var lastSubmissionTime: Date?
    
    /// Submit a rating for a stand
    func submitRating(deviceUUID: String, standID: Int) {
        guard let currentRating else { return }
        guard currentRating >= 1 && currentRating <= 5 else {
            self.errorMessage = "Rating must be between 1 and 5"
            return
        }
        
        // Check cooldown
        if let lastTime = lastSubmissionTime {
            let elapsed = Date().timeIntervalSince(lastTime)
            if elapsed < 60 {
                //self.errorMessage = "Bitte warte 5 min..."
                return
            }
        }
        
        self.isSubmitting = true
        self.errorMessage = nil
        self.successMessage = nil
        
        // Prepare URL
        guard let url = URL(string: "\(domain)/api/stands/rate") else {
            self.errorMessage = "Invalid URL"
            self.isSubmitting = false
            return
        }
        
        // Prepare request body
        let body: [String: Any] = [
            "device_uuid": deviceUUID,
            "stand_id": standID,
            "rating": currentRating
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            self.errorMessage = "Failed to encode request"
            self.isSubmitting = false
            return
        }
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Send request
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isSubmitting = false
                
                if let error = error {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.errorMessage = "Invalid response"
                    return
                }
                
                if (200...299).contains(httpResponse.statusCode) {
                    self.successMessage = "Bewertung erfolgreich"
                    self.lastSubmissionTime = Date()
                } else {
                    self.errorMessage = "Server error: \(httpResponse.statusCode)"
                }
            }
        }.resume()
    }
    
    /// Get rating for a specific device and stand
    func getRating(for deviceUUID: String, standID: Int) {
        guard let url = URL(string: "\(domain)/api/stands/rating?device_uuid=\(deviceUUID)&stand_id=\(standID)") else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }
                
                struct DeviceStandRatingResponse: Codable {
                    let device_uuid: String
                    let stand_id: Int
                    let rating: Int?
                }
                
                do {
                    let decoded = try JSONDecoder().decode(DeviceStandRatingResponse.self, from: data)
                    self.currentRating = decoded.rating
                } catch {
                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

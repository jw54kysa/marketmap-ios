//
//  InitManager.swift
//  XmasMarket
//
//  Created by Private Jon  on 20.10.25.
//
import SwiftUI

let domain: String = "https://marketmap-app.de"

class InitManager: ObservableObject {
    
    static var shared: InitManager = InitManager()
    
    @Published var selectedMarket: String? {
        didSet {
            UserDefaults.standard.set(selectedMarket, forKey: "selectedMarket")
            print("Selected Market: \(selectedMarket ?? "None")")
        }
    }
    
    @Published var availableMarkets: [String]?
    @Published var deviceID: String?
    
    private init() {
        self.selectedMarket = UserDefaults.standard.string(forKey: "selectedMarket")
        print("Selected Market: \(selectedMarket ?? "None")")
    }
    
    func getDeviceID() -> String {
        if let savedID = UserDefaults.standard.string(forKey: "deviceID") {
            return savedID
        } else {
            let newID = UUID().uuidString
            UserDefaults.standard.set(newID, forKey: "deviceID")
            return newID
        }
    }
    
    func sendDeviceActivation() {
        let deviceUUID = getDeviceID()
        
        guard let url = URL(string: "\(domain)/api/tracker/activate") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["uuid": deviceUUID]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending activation: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(ActivationResponse.self, from: data)
                let marketsList = decoded.markets
                
                DispatchQueue.main.async {
                    self.availableMarkets = marketsList
                }
                
                print("Available Markets: \(marketsList)")
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct ActivationResponse: Codable {
    let uuid: String
    let markets: [String]
}

//
//  StandManager.swift
//  XmasMarket
//
//  Created by Private Jon  on 08.10.25.
//


import Foundation
import SwiftUI
import Combine

class StandManager: ObservableObject {
    @Published var stands: [Stand] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let cacheFileName = "stands.json"
    
    private var marketSelectedNotification: AnyCancellable?
    private var marketSelectedNotificationNil: AnyCancellable?

    init() {
        if InitManager.shared.selectedMarket != nil {
            loadFromCache()
            fetchStands()
        }
        
        marketSelectedNotification = NotificationCenter.default
                    .publisher(for: .selectedMarket)
                    .sink { _ in
                        self.loadFromCache()
                        self.fetchStands()
                    }
        
        marketSelectedNotificationNil = NotificationCenter.default
            .publisher(for: .selectedMarketNil)
            .sink { _ in
                self.stands.removeAll()
            }
    }

    // MARK: - Paths

    private var cacheURL: URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(cacheFileName)
    }

    // MARK: - Cache

    private func saveToCache(_ stands: [Stand]) {
        do {
            let data = try JSONEncoder().encode(stands)
            try data.write(to: cacheURL)
            print("💾 saved to cached")
        } catch {
            print("Failed to write cache: \(error.localizedDescription)")
        }
    }

    private func loadFromCache() {
        guard FileManager.default.fileExists(atPath: cacheURL.path) else {
            print("No cache file found")
            return
        }

        do {
            let data = try Data(contentsOf: cacheURL)
            let cachedStands = try JSONDecoder().decode([Stand].self, from: data)
            self.stands = cachedStands.filter { $0.name == InitManager.shared.selectedMarket!.self }
            print("💾 loaded from cached")
        } catch {
            print("Failed to load cache: \(error.localizedDescription)")
        }
    }

    // MARK: - Network

    func fetchStands() {
        isLoading = true
        errorMessage = nil
        
        guard let selectedMarket = InitManager.shared.selectedMarket,
                let apiURL = URL(string: "\(domain)/api/stands?event=\(selectedMarket)")
        else { return }

        URLSession.shared.dataTask(with: apiURL) { data, response, error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isLoading = false
            }

            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    print("📉❌ fetched network error")
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                    print("📉❌ fetched no data")
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode([Stand].self, from: data)
                DispatchQueue.main.async {
                    self.stands = decoded
                }
                print("📉 fetched")
                self.saveToCache(decoded)
            } catch {
                DispatchQueue.main.async {
                    print(data)
                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
                    print("📉❌ fetched decoding error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    // MARK: Types
    
    /// return all Types
    func getAllTypes() -> [BoothType] {
        let counts = Dictionary(grouping: stands.map(\.boothType), by: { $0 })
            .mapValues { $0.count }
        
        return counts
            .sorted { $0.value > $1.value }
            .map { $0.key }
    }
}

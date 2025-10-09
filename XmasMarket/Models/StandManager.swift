//
//  StandManager.swift
//  XmasMarket
//
//  Created by Private Jon  on 08.10.25.
//


import Foundation
import SwiftUI

class StandManager: ObservableObject {
    @Published var stands: [Stand] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let cacheFileName = "stands.json"
    private let apiURL = URL(string: "http://localhost:8000/api/stands")!

    init() {
        loadFromCache()
        fetchStands()
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
            self.stands = cachedStands
            print("💾 loaded from cached")
        } catch {
            print("Failed to load cache: \(error.localizedDescription)")
        }
    }

    // MARK: - Network

    func fetchStands() {
        isLoading = true
        errorMessage = nil

        URLSession.shared.dataTask(with: apiURL) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }

            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
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
                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

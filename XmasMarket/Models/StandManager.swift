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
    
    // Filter Manager
    @Published var availableTypes: Set<BoothType> = []
    @Published var availableOffers: Set<Offer> = []
    
    @Published var selectedTypes: Set<BoothType> = []
    @Published var selectedOffers: Set<Offer> = []
    
    func toggleSelection(ofType type: BoothType) {
        if selectedTypes.contains(type) {
            selectedTypes.remove(type)
        } else {
            selectedTypes.insert(type)
        }
    }
    
    func toggleSelection(ofOffer offer: Offer) {
        if selectedOffers.contains(offer) {
            selectedOffers.remove(offer)
        } else {
            selectedOffers.insert(offer)
        }
    }

    private let cacheFileName = "stands.json"
    
    private var marketSelectedNotification: AnyCancellable?
    private var marketSelectedNotificationNil: AnyCancellable?

    init() {
        if InitManager.shared.selectedMarket != nil {
            loadFromCache()
            fetchStands()
            updateFilterManager()
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
            if let selectedMarket = InitManager.shared.selectedMarket {
                self.stands = cachedStands.filter { $0.event == selectedMarket }
            } else {
                self.stands = cachedStands
            }
            print("💾 loaded from cache: \(stands.count)")
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
                    self.loadFromCache()
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                    print("📉❌ fetched no data")
                    self.loadFromCache()
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
                    self.loadFromCache()
                }
            }
        }.resume()
    }
    
    // MARK: Filter Manager
    
    func updateFilterManager() {
        availableTypes = getAllTypes()
        availableOffers = getAllOffers()
    }
    
    /// return all Types
    func getAllTypes() -> Set<BoothType> {
        return Set(stands.map(\.boothType))
    }
    
    /// return all Types
    func getAllOffers() -> Set<Offer> {
        return Set(stands.flatMap(\.offers))
    }
}

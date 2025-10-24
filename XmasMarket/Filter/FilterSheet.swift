//
//  FilterSheet.swift
//  MarketMap
//
//  Created by Private Jon  on 24.10.25.
//
import SwiftUI

struct FilterSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var standManager: StandManager
    
    let adaptiveColumns = [
        GridItem(.adaptive(minimum: 120))
    ]
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                VStack(spacing: 20) {
                    if !standManager.selectedTypes.isEmpty {
                        HStack {
                            Text("Ausgewählte Filter:")
                                .font(.callout)
                            Spacer()
                        }
                        
                        LazyVGrid(columns: adaptiveColumns, spacing: 16) {
                            ForEach(Array(standManager.selectedTypes), id: \.self) { type in
                                FilterBubble(type: type,
                                             isSelected: standManager.selectedTypes.contains(type),
                                             onTap: {
                                    withAnimation(.easeInOut) {
                                        standManager.toggleSelection(ofType: type)
                                    }
                                })
                            }
                        }
                    }
                    
                    HStack {
                        Text("Buden")
                            .font(.title3)
                            .bold()
                        Spacer()
                    }
                    
                    LazyVGrid(columns: adaptiveColumns, spacing: 16) {
                        ForEach(Array(standManager.availableTypes), id: \.self) { type in
                            FilterBubble(type: type,
                                         isSelected: standManager.selectedTypes.contains(type),
                                         onTap: {
                                withAnimation(.easeInOut) {
                                    standManager.toggleSelection(ofType: type)
                                }
                            })
                        }
                    }
                    
                    Divider()
                    HStack {
                        Text("Angebote")
                            .font(.title3)
                            .bold()
                        Spacer()
                    }
                    
                    LazyVGrid(columns: adaptiveColumns, spacing: 16) {
                        ForEach(Array(standManager.availableOffers), id: \.self) { offer in
                            FilterBubbleOffer(offer: offer,
                                              isSelected: standManager.selectedOffers.contains(offer),
                                              onTap: {
                                standManager.toggleSelection(ofOffer: offer)
                            })
                        }
                    }
                    
                    Text("Ausgewählte Buden: \(standManager.filteredLocations.count)")
                        .font(.callout)
                    
                    Button(action: {
                        InitManager.shared.selectedMarket = nil
                        NotificationCenter.default.post(name: .selectedMarketNil, object: nil)
                        dismiss()
                    }, label: {
                        Text("Einen anderen Markt besuchen ->")
                    })
                }
                .padding()
            }
            .navigationTitle("Filter")
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button(action: {
                        standManager.selectedTypes.removeAll()
                        standManager.selectedOffers.removeAll()
                    }, label: {
                        Image(systemName: "trash")
                    })
                }
            }
        }
    }
}


#Preview {
    FilterSheet(standManager: StandManager())
}

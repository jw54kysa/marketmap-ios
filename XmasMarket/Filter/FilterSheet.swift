//
//  FilterSheet.swift
//  MarketMap
//
//  Created by Private Jon  on 24.10.25.
//
import SwiftUI

struct FilterSheet: View {
    
    @ObservedObject var standManager: StandManager
    
    let adaptiveColumns = [
        GridItem(.adaptive(minimum: 120))
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    
                    HStack {
                        Text("Stände")
                            .font(.headline)
                        Spacer()
                    }
                    
                    LazyVGrid(columns: adaptiveColumns, spacing: 16) {
                        ForEach(Array(standManager.availableTypes), id: \.self) { type in
                            FilterBubble(type: type,
                                         isSelected: standManager.selectedTypes.contains(type),
                                         onTap: {
                                standManager.toggleSelection(ofType: type)
                            })
                        }
                    }
                    
                    
                    Divider()
                    HStack {
                        Text("Angebote")
                            .font(.headline)
                        Spacer()
                    }
                    
                    LazyVGrid(columns: adaptiveColumns, spacing: 16) {
                        ForEach(Array(standManager.availableOffers), id: \.self) { offer in
                            FilterBubbleOffer(offer: offer,
                                              isSelected: standManager.selectedOffers.contains(offer),
                                              onTap: {
                                standManager.toggleSelection(ofOffer: offer)
                            }
                            )
                        }
                    }
                }
                .padding()
            }.navigationTitle("Filter")
        }
    }
}


#Preview {
    FilterSheet(standManager: StandManager())
}

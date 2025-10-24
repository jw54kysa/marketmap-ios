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
            VStack {
                ScrollView {
                    HStack {
                        Text("Stände")
                            .font(.title3)
                            .bold()
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
                            }
                            )
                        }
                    }
                }
                .padding()
                
                Button(action: {
                    InitManager.shared.selectedMarket = nil
                    NotificationCenter.default.post(name: .selectedMarketNil, object: nil)
                    dismiss()
                }, label: {
                    Text("Einen anderen Markt besuchen ->")
                })
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

//
//  StandListView.swift
//  XmasMarket
//
//  Created by Private Jon  on 08.10.25.
//
import SwiftUI

struct StandListView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var standManager: StandManager
    @Binding var selectedTypes: Set<BoothType>
    @State private var selectedStand: Stand? = nil
    
    var filteredLocations: [Stand] {
        if selectedTypes.isEmpty {
            return standManager.stands
        } else {
            return standManager.stands.filter { return selectedTypes.map{$0.rawValue}.contains($0.type)}
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if standManager.isLoading {
                    SnowfallLoadingOverlay()
                } else if let error = standManager.errorMessage {
                    Text("\(error)").foregroundColor(.red)
                } else {
                    List {
                        Section(header:
                                    BubbleView(standManager: standManager, selectedTypes: $selectedTypes)
                            .padding(.horizontal, -30)
                            .listRowBackground(Color.clear)
                        ) {
                            ForEach(filteredLocations) { stand in
                                HStack(spacing: 10) {
                                    Text(stand.boothType.icon)
                                        .font(.title)
                                    VStack(alignment: .leading) {
                                        Text(stand.name)
                                            .font(.headline)
                                        Text(stand.boothType.displayName)
                                            .font(.subheadline)
                                    }
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedStand = stand
                                }
                            }
                        }
                        
                    }
                    
                }
            }
            .animation(.easeInOut, value: standManager.isLoading)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        InitManager.shared.selectedMarket = nil
                        NotificationCenter.default.post(name: .selectedMarketNil, object: nil)
                        dismiss()
                    }) {
                        Image(systemName: "arrow.trianglehead.swap")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        standManager.fetchStands()
                    }) {
                        Image(systemName: "arrow.trianglehead.counterclockwise")
                    }
                }
            }
            .navigationTitle("Stände")
            .navigationBarTitleDisplayMode(.automatic)
            
            // MARK: SHEET
            .sheet(item: $selectedStand) { stand in
                BoothDetailSheet(stand: stand)
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

#Preview {
    StandListView(standManager: StandManager(), selectedTypes: .constant([]))
}

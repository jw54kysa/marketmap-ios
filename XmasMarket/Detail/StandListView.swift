//
//  StandListView.swift
//  XmasMarket
//
//  Created by Private Jon  on 08.10.25.
//
import SwiftUI

struct StandListView: View {
    @ObservedObject var standManager: StandManager
    
    @State private var selectedStand: Stand? = nil

    var body: some View {
        NavigationView {
            if standManager.isLoading {
                
            } else if let error = standManager.errorMessage {
                Text("Error: \(error)").foregroundColor(.red)
            } else {
                List(standManager.stands) { stand in
                    HStack(spacing: 10) {
                        Text(stand.icon ?? "")
                            .font(.title)
                        VStack(alignment: .leading) {
                            Text(stand.name)
                                .font(.headline)
                            Text(stand.boothType.displayName)
                                .font(.subheadline)
//                            Text("Offen von \(stand.open_time) - \(stand.close_time)")
//                                .font(.caption)
                        }
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedStand = stand
                    }
                }
                .navigationTitle("Stände")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            standManager.fetchStands()
                        }) {
                            Image(systemName: "arrow.trianglehead.counterclockwise")
                        }
                    }
                }
                
                // MARK: SHEET
                
                .sheet(item: $selectedStand) { stand in
                    BoothDetailSheet(stand: stand)
                        .presentationDetents([.medium, .large])
                }
            }
        }
    }
}

#Preview {
    StandListView(standManager: StandManager())
}

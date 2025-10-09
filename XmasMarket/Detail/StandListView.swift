//
//  StandListView.swift
//  XmasMarket
//
//  Created by Private Jon  on 08.10.25.
//
import SwiftUI

struct StandListView: View {
    @ObservedObject var standManager: StandManager

    var body: some View {
        NavigationView {
            if standManager.isLoading {
                ProgressView("Loading...")
            } else if let error = standManager.errorMessage {
                Text("Error: \(error)").foregroundColor(.red)
            } else {
                List(standManager.stands) { stand in
                    VStack(alignment: .leading) {
                        Text(stand.name)
                            .font(.headline)
                        Text(stand.type)
                            .font(.subheadline)
                        Text("Open: \(stand.open_time) - \(stand.close_time)")
                            .font(.caption)
                    }
                }
                .navigationTitle("Stands")
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    standManager.fetchStands()
                }) {
                    Image(systemName: "arrow.trianglehead.counterclockwise")
                }
            }
        }
    }
}


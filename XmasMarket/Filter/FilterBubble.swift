//
//  FilterBubble.swift
//  XmasMarket
//
//  Created by Private Jon  on 08.10.25.
//
import SwiftUI

struct BubbleView: View {
    
    @Binding var selectedTypes: Set<BoothType>
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(BoothType.allCasesBut) { type in
                        FilterBubble(type: type, isSelected: selectedTypes.contains(type)) {
                            if selectedTypes.contains(type) {
                                selectedTypes.remove(type)
                            } else {
                                selectedTypes.insert(type)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            Spacer()
        }
    }
}

struct FilterBubble: View {
    let type: BoothType
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Text(type.icon + type.displayName)
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .stroke(type.color.opacity(isSelected ? 0.9 : 0.4), lineWidth: 2)
                    )
            )
            .foregroundColor(isSelected ? type.color : .gray)
            .onTapGesture { onTap() }
    }
}

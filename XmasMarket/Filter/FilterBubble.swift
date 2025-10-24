//
//  FilterBubble.swift
//  XmasMarket
//
//  Created by Private Jon  on 08.10.25.
//
import SwiftUI

struct OutlinedText: View {
    var text: String
    var font: Font = .system(size: 48, weight: .bold)
    var foreground: Color = .white
    var outline: Color = .black
    var lineWidth: CGFloat = 2
    
    private var offsets: [CGPoint] {
        [CGPoint(x: -lineWidth, y: -lineWidth),
         CGPoint(x:  lineWidth, y: -lineWidth),
         CGPoint(x: -lineWidth, y:  lineWidth),
         CGPoint(x:  lineWidth, y:  lineWidth),
         CGPoint(x: 0, y: -lineWidth),
         CGPoint(x: 0, y:  lineWidth),
         CGPoint(x: -lineWidth, y: 0),
         CGPoint(x:  lineWidth, y: 0)]
    }
    
    var body: some View {
        ZStack {
            ForEach(offsets, id: \.self) { off in
                Text(text)
                    .font(font)
                    .foregroundColor(outline)
                    .offset(x: off.x, y: off.y)
            }
            Text(text)
                .font(font)
                .foregroundColor(foreground)
        }
    }
}


struct BubbleView: View {
    @ObservedObject var standManager: StandManager
    
    @State var showFilterSheet: Bool = false
    
    var body: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    Text(" ")
                    ForEach(sortedBoothTypes) { type in
                        FilterBubble(type: type, isSelected: standManager.selectedTypes.contains(type)) {
                            withAnimation(.easeInOut) {
                                standManager.toggleSelection(ofType: type)
                            }
                        }
                    }
                    Text(" ")
                }
            }
            Button(action: {
                showFilterSheet.toggle()
            }, label: {
                Image(systemName: "slider.horizontal.3")
            })
            .padding(.trailing)
        }
        .padding(.vertical, 8)
        .sheet(isPresented: $showFilterSheet) {
            FilterSheet(standManager: standManager)
        }
    }
    
    private var sortedBoothTypes: [BoothType] {
        standManager.getAllTypes().sorted {
            let isFirstSelected = standManager.selectedTypes.contains($0)
            let isSecondSelected = standManager.selectedTypes.contains($1)
            
            if isFirstSelected == isSecondSelected {
                return $0.rawValue < $1.rawValue
            }
            return isFirstSelected && !isSecondSelected
        }
    }
}

struct FilterBubble: View {
    let type: BoothType
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Group {
            Text(type.icon + type.displayName)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(type.color.opacity(isSelected ? 0.3 : 0.1))
                        .overlay(
                            Capsule()
                                .stroke(type.color.opacity(isSelected ? 0.9 : 0.4), lineWidth: 2)
                        )
                )
                .foregroundColor(isSelected ? type.color : .gray)
        }
        .onTapGesture { onTap() }
    }
}

struct FilterBubbleOffer: View {
    let offer: Offer
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Group {
            Text(offer.icon ?? "" + offer.name)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(offer.color.opacity(isSelected ? 0.3 : 0.1))
                        .overlay(
                            Capsule()
                                .stroke(offer.color.opacity(isSelected ? 0.9 : 0.4), lineWidth: 2)
                        )
                )
                .foregroundColor(isSelected ? offer.color : .gray)
        }
        .onTapGesture { onTap() }
    }
}

#Preview {
    @Previewable @State var selectedTypes: Set<BoothType> = []
    BubbleView(standManager: StandManager())
}

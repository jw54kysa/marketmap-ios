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
                    ForEach(standManager.sortedBoothTypes) { type in
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
}

struct FilterBubble: View {
    let type: BoothType
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Group {
            Text((type.icon ?? "") + " " + type.name)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(type.getColor().opacity(isSelected ? 0.5 : 0.3))
                        .overlay(
                            Capsule()
                                .stroke(type.getColor().opacity(isSelected ? 0.9 : 0.4), lineWidth: 2)
                        )
                )
                .foregroundColor(.primary)
        }
        .padding(1)
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

    let standManager = StandManager()
    InitManager.shared.selectedMarket = "25_lpz_wm"
    
    return BubbleView(standManager: standManager)
}

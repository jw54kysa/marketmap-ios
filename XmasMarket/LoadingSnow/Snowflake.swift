//
//  Snowflake.swift
//  XmasMarket
//
//  Created by Private Jon  on 09.10.25.
//


import SwiftUI

struct Snowflake: View {
    var size: CGFloat
    var xPosition: CGFloat
    var initialYPosition: CGFloat
    var fallDuration: Double
    var delay: Double

    @State private var yOffset: CGFloat = -200

    var body: some View {
        Circle()
            .fill(Color.white.opacity(0.8))
            .frame(width: size, height: size)
            .position(x: xPosition, y: yOffset)
            .onAppear {
                yOffset = initialYPosition
                withAnimation(
                    Animation.linear(duration: fallDuration)
                        .delay(calcDelay())
                        .repeatForever(autoreverses: false)
                ) {
                    yOffset = UIScreen.main.bounds.height + 100
                }
            }
    }
    
    func calcDelay() -> CGFloat {
        if initialYPosition > -100 {
            return 0
        } else {
            return delay
        }
        
    }
}

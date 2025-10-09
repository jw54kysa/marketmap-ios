//
//  SnowfallLoadingOverlay.swift
//  XmasMarket
//
//  Created by Private Jon  on 09.10.25.
//
import SwiftUI

struct SnowfallLoadingOverlay: View {
    let snowflakeCount = 200

    var body: some View {
        ZStack {
            // Optional: Dim background
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            // Snowflakes
            ForEach(0..<snowflakeCount, id: \.self) { i in
                Snowflake(
                    size: CGFloat.random(in: 4...10),
                    xPosition: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    initialYPosition: CGFloat.random(in: -UIScreen.main.bounds.height...UIScreen.main.bounds.height),
                    fallDuration: Double.random(in: 4...10),
                    delay: Double.random(in: 0...6)
                )
            }

            // Optional: Loading Indicator or Logo
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                    .padding(.top, 40)

                Text("Loading...")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding(.top, 10)
            }
        }
    }
}

#Preview {
    SnowfallLoadingOverlay()
}

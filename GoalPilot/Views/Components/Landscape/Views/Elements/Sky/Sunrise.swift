//
//  Sunrise.swift
//  GoalPilot
//
//  Created by Rune Pollet on 23/11/2024.
//

import SwiftUI

extension Landscape {
    /// A sky that represents sunrise.
    struct Sunrise: View {
        var body: some View {
            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height
                
                Sun(color: .orange.opacity(0.5))
                    .frame(width: width * 377/924, height: width * 377/924)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .offset(x: width * -40/393, y: height * -10/852)
                    .clipped()
            }
        }
    }
}

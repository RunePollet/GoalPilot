//
//  Day.swift
//  GoalPilot
//
//  Created by Rune Pollet on 24/11/2024.
//

import SwiftUI

extension Landscape {
    /// A sky that represents daytime.
    struct Day: View {
        var body: some View {
            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height
                
                Sun(lineWidth: 0.7)
                    .frame(width: width * 35/393, height: width * 35/393)
                    .offset(x: width * -0.1, y: height * 0.05)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }
        }
    }
}

//
//  Sun.swift
//  GoalPilot
//
//  Created by Rune Pollet on 02/09/2024.
//

import SwiftUI

extension Landscape {
    struct Sun: View {
        var lineWidth: CGFloat = 15/39
        var color: Color = .yellow
        
        var body: some View {
            GeometryReader { geo in
                ZStack {
                    Circle()
                        .stroke(color.opacity(0.5), lineWidth: lineWidth * geo.size.minDimension)
                    Circle()
                        .foregroundStyle(color)
                }
                .shadow(color: TimeOfDayService.current() == .day ? .white.opacity(0.6) : .clear, radius: 20)
            }
        }
    }
}


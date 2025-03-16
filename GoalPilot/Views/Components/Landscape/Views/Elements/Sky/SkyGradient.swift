//
//  SkyGradient.swift
//  GoalPilot
//
//  Created by Rune Pollet on 10/12/2024.
//

import SwiftUI

extension Landscape {
    /// A gradient representing the sky at the given time of day.
    struct SkyGradient: View {
        
        var timeOfDay: TimeOfDayService.TimeOfDay
        var stop: CGFloat = 0
        
        private var topColor: Color {
            switch timeOfDay {
            case .day, .sunrise:
                Color.blue.opacity(0.3)
            case .sunset:
                Color.blue.opacity(0.1)
            case .night:
                Color.black
            }
        }
        private var bottomColor: Color {
            switch timeOfDay {
            case .sunrise:
                Color.orange.opacity(0.5)
            case .day:
                Color.white
            case .sunset:
                Color.orange.opacity(0.4)
            case .night:
                Color.black
            }
        }
        
        var body: some View {
            LinearGradient(
                stops: [
                    .init(color: topColor, location: stop),
                    .init(color: bottomColor, location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .top)
        }
    }
}

//
//  Star.swift
//  GoalPilot
//
//  Created by Rune Pollet on 13/01/2024.
//

import SwiftUI

extension StarFigure {
    /// Describes a star shape in the star figure.
    struct Star {
        var scale: CGFloat = 1
        var rotation: Angle = .degrees(0)
        /// In percentages of the available frame
        var offset: CGSize = CGSize(width: 0, height: 0)
    }
}

extension StarFigure.Star: Equatable {
    static func == (lhs: StarFigure.Star, rhs: StarFigure.Star) -> Bool {
        return lhs.offset == rhs.offset && lhs.rotation == rhs.rotation && lhs.scale == rhs.scale
    }
}

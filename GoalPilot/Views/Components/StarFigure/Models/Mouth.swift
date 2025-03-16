//
//  Mouth.swift
//  GoalPilot
//
//  Created by Rune Pollet on 13/01/2024.
//

import SwiftUI

extension StarFigure {
    /// Describes a mouth in the star figure.
    struct Mouth {
        /// In percentages of the available frame
        var frame: (width: CGFloat, height: CGFloat) = (100/300, 50/300)
        var flip: Bool = false
        var scale: CGFloat = 1
        var opacity: CGFloat = 1
    }
}

extension StarFigure.Mouth: Equatable {
    static func == (lhs: StarFigure.Mouth, rhs: StarFigure.Mouth) -> Bool {
        return  lhs.frame == rhs.frame && lhs.flip == rhs.flip && lhs.scale == rhs.scale && lhs.opacity == rhs.opacity
    }
}

//
//  Eyebrow.swift
//  GoalPilot
//
//  Created by Rune Pollet on 13/01/2024.
//

import SwiftUI

extension StarFigure {
    /// Describes an eyebrow in the star figure.
    struct Eyebrow {
        /// In percentages of the available frame
        var frame: (width: CGFloat, height: CGFloat)
        var rotation: Angle
        /// In percentages of the available frame
        var rotationAnchor: UnitPoint
        /// In percentages of the available frame
        var offset: (x: CGFloat, y: CGFloat)
        var scale: CGFloat
        var scaleAnchor: UnitPoint
        var opacity: CGFloat
        
        init(side: Side,
             frame: (width: CGFloat, height: CGFloat) = (50/300, 20/300),
             rotation: Angle? = nil,
             rotationAnchor: UnitPoint = .center,
             offset: (x: CGFloat, y: CGFloat)? = nil,
             scale: CGFloat = 1,
             scaleAnchor: UnitPoint? = nil,
             opacity: CGFloat = 1) {
            self.frame = frame
            self.rotation = rotation ?? (side == .left ? .degrees(-20) : .degrees(20))
            self.rotationAnchor = rotationAnchor
            self.offset = offset ?? (x: side == .left ? -3/300 : 3/300, y: -30/300)
            self.scale = scale
            self.scaleAnchor = scaleAnchor ?? (side == .left ? .trailing : .leading)
            self.opacity = opacity
        }
    }
}

extension StarFigure.Eyebrow: Equatable {
    static func == (lhs: StarFigure.Eyebrow, rhs: StarFigure.Eyebrow) -> Bool {
        return lhs.frame == rhs.frame && lhs.rotation == rhs.rotation && lhs.rotationAnchor == rhs.rotationAnchor && lhs.offset == rhs.offset && lhs.scale == rhs.scale && lhs.scaleAnchor == rhs.scaleAnchor && lhs.opacity == rhs.opacity
    }
}


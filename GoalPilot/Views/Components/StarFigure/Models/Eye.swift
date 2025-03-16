//
//  Eye.swift
//  GoalPilot
//
//  Created by Rune Pollet on 13/01/2024.
//

import SwiftUI

extension StarFigure {
    /// Describes an eye in the star figure.
    struct Eye {
        var open: Bool
        var closed: Bool
        var hFlip: Bool
        /// In percentages of the available frame
        var frame: (width: CGFloat, height: CGFloat)
        /// In percentages of the frame
        var eyeFrame: (width: CGFloat, height: CGFloat)
        /// In percentages of the frame
        var closedFrame: (width: CGFloat, height: CGFloat)
        /// In percentages of the available frame for the eye
        var pupilFrame: (width: CGFloat, height: CGFloat)
        var keepPupilSymmetry: Bool = false
        /// In percentages of the available frame for the eye
        var pupilOffset: (x: CGFloat, y: CGFloat)
        var scale: CGFloat
        var scaleAnchor: UnitPoint
        var opacity: CGFloat
        var closedOpacity: CGFloat
        
        init(side: Side,
             open: Bool = true,
             closed: Bool = false,
             frame: (width: CGFloat, height: CGFloat) = (40/300, 40/300),
             eyeFrame: (width: CGFloat, height: CGFloat) = (1, 1),
             closedFrame: (width: CGFloat, height: CGFloat) = (1, 1),
             pupilFrame: (width: CGFloat, height: CGFloat) = (112.5/300, 112.5/300),
             keepPupilSymmetry: Bool = false,
             pupilOffset: (x: CGFloat, y: CGFloat) = (0, 0),
             scale: CGFloat = 1,
             scaleAnchor: UnitPoint? = nil,
             opacity: CGFloat = 1,
             closedOpacity: CGFloat = 1) {
            self.open = open
            self.closed = closed
            self.hFlip = side == .right
            self.frame = frame
            self.eyeFrame = eyeFrame
            self.closedFrame = closedFrame
            self.pupilFrame = pupilFrame
            self.keepPupilSymmetry = keepPupilSymmetry
            self.pupilOffset = pupilOffset
            self.scale = scale
            self.scaleAnchor = scaleAnchor ?? (side == .right ? .leading : .trailing)
            self.opacity = opacity
            self.closedOpacity = closedOpacity
        }
    }
}

extension StarFigure.Eye: Equatable {
    static func == (lhs: StarFigure.Eye, rhs: StarFigure.Eye) -> Bool {
        return lhs.closed == rhs.closed && lhs.frame == rhs.frame && lhs.pupilFrame == rhs.pupilFrame && lhs.keepPupilSymmetry == rhs.keepPupilSymmetry && lhs.pupilOffset == rhs.pupilOffset && lhs.scale == rhs.scale && lhs.scaleAnchor == rhs.scaleAnchor && lhs.opacity == rhs.opacity
    }
}

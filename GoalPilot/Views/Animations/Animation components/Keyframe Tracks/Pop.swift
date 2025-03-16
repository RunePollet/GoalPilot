//
//  Pop.swift
//  GoalPilot
//
//  Created by Rune Pollet on 19/12/2024.
//

import SwiftUI

extension StarFigure.StarView {
    /// Pops the star figure's expression.
    @KeyframesBuilder<StarFigure.StarViewConfiguration>
    static func popKeyframes(_ value: StarFigure.StarViewConfiguration) -> some Keyframes<StarFigure.StarViewConfiguration> {
        // Star
        KeyframeTrack(\StarFigure.StarViewConfiguration.star.scale) {
            SpringKeyframe(1.3, duration: 0.2, spring: .smooth, startVelocity: 2)
            SpringKeyframe(1, duration: 0.5, spring: .bouncy(extraBounce: 0.2))
            LinearKeyframe(1, duration: 0.8)
        }
        
        // Eyes
        KeyframeTrack(\StarFigure.StarViewConfiguration.leftEye.scale) {
            LinearKeyframe(1, duration: 0.1)
            SpringKeyframe(1.3, duration: 0.2, spring: .smooth, startVelocity: 2)
            SpringKeyframe(1, duration: 0.5, spring: .bouncy(extraBounce: 0.2))
            LinearKeyframe(1, duration: 0.7)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.leftEye.opacity) {
            LinearKeyframe(0, duration: 0.1)
            SpringKeyframe(1, duration: 0.2, spring: .smooth, startVelocity: 2)
            LinearKeyframe(1, duration: 1.2)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.rightEye.scale) {
            LinearKeyframe(1, duration: 0.15)
            SpringKeyframe(1.31, duration: 0.2, spring: .smooth, startVelocity: 2)
            SpringKeyframe(1, duration: 0.5, spring: .bouncy(extraBounce: 0.2))
            LinearKeyframe(1, duration: 0.65)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.rightEye.opacity) {
            LinearKeyframe(0, duration: 0.15)
            SpringKeyframe(1, duration: 0.2, spring: .smooth, startVelocity: 2)
            LinearKeyframe(1, duration: 1.15)
        }
        
        // Eyebrows
        KeyframeTrack(\StarFigure.StarViewConfiguration.leftEyebrow.scale) {
            LinearKeyframe(1, duration: 0.15)
            SpringKeyframe(1.3, duration: 0.2, spring: .smooth, startVelocity: 2)
            SpringKeyframe(1, duration: 0.5, spring: .bouncy(extraBounce: 0.2))
            LinearKeyframe(1, duration: 0.65)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.leftEyebrow.opacity) {
            LinearKeyframe(0, duration: 0.15)
            SpringKeyframe(1, duration: 0.2, spring: .smooth, startVelocity: 2)
            LinearKeyframe(1, duration: 1.15)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.rightEyebrow.scale) {
            LinearKeyframe(1, duration: 0.2)
            SpringKeyframe(1.31, duration: 0.2, spring: .smooth, startVelocity: 2)
            SpringKeyframe(1, duration: 0.5, spring: .bouncy(extraBounce: 0.2))
            LinearKeyframe(1, duration: 0.5)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.rightEyebrow.opacity) {
            LinearKeyframe(0, duration: 0.2)
            SpringKeyframe(1, duration: 0.2, spring: .smooth, startVelocity: 2)
            LinearKeyframe(1, duration: 1.1)
        }
        
        // Mouth
        KeyframeTrack(\StarFigure.StarViewConfiguration.mouth.scale) {
            LinearKeyframe(1, duration: 0.3)
            SpringKeyframe(1.3, duration: 0.2, spring: .smooth, startVelocity: 2)
            SpringKeyframe(1, duration: 0.5, spring: .bouncy(extraBounce: 0.2))
            LinearKeyframe(1, duration: 0.5)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.mouth.opacity) {
            LinearKeyframe(0, duration: 0.3)
            SpringKeyframe(1, duration: 0.2, spring: .smooth, startVelocity: 2)
            LinearKeyframe(1, duration: 1)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.mouth.frame.height) {
            LinearKeyframe(50/300, duration: 0.5)
            SpringKeyframe(65/300, duration: 1.5, spring: .smooth(extraBounce: 0.1))
        }
    }
}

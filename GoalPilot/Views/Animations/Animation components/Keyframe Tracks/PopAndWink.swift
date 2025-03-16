//
//  PopAndWink.swift
//  GoalPilot
//
//  Created by Rune Pollet on 19/12/2024.
//

import SwiftUI

extension StarFigure.StarView {
    /// Pops the star figure's expression and let's it wink.
    @KeyframesBuilder<StarFigure.StarViewConfiguration>
    static func popAndWinkKeyframes(_ value: StarFigure.StarViewConfiguration) -> some Keyframes<StarFigure.StarViewConfiguration> {
        // Star
        KeyframeTrack(\StarFigure.StarViewConfiguration.star.scale) {
            SpringKeyframe(1.3, duration: 0.2, spring: .smooth, startVelocity: 2)
            SpringKeyframe(1, duration: 0.5, spring: .bouncy(extraBounce: 0.2))
            LinearKeyframe(1, duration: 1.5)
        }
        
        // Left eye
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
        KeyframeTrack(\StarFigure.StarViewConfiguration.leftEye.frame.width) {
            let value = value.leftEye.frame.width
            LinearKeyframe(value, duration: 1.5)
            LinearKeyframe(35/40 * value, duration: 0.2)
            LinearKeyframe(35/40 * value, duration: 0.2)
            LinearKeyframe(value, duration: 0.3)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.leftEye.frame.height) {
            let value = value.leftEye.frame.height
            LinearKeyframe(value, duration: 1.5)
            LinearKeyframe(45/40 * value, duration: 0.2)
            LinearKeyframe(45/40 * value, duration: 0.2)
            LinearKeyframe(value, duration: 0.3)
        }
        
        // Right eye
        KeyframeTrack(\StarFigure.StarViewConfiguration.rightEye.scale) {
            LinearKeyframe(1, duration: 0.15)
            SpringKeyframe(1.31, duration: 0.2, spring: .smooth, startVelocity: 2)
            SpringKeyframe(1, duration: 0.5, spring: .bouncy(extraBounce: 0.2))
            LinearKeyframe(1, duration: 0.65)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.rightEye.eyeFrame.height) {
            let value = value.rightEye.eyeFrame.height
            LinearKeyframe(value, duration: 1.5)
            LinearKeyframe(0.2/1 * value, duration: 0.10)
            LinearKeyframe(0.2/1 * value, duration: 0.40)
            LinearKeyframe(value, duration: 0.20)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.rightEye.opacity) {
            LinearKeyframe(0, duration: 0.15)
            SpringKeyframe(1, duration: 0.2, spring: .smooth, startVelocity: 2)
            LinearKeyframe(1, duration: 1.15)
            LinearKeyframe(0, duration: 0.10)//1.6s passed
            LinearKeyframe(0, duration: 0.40)
            LinearKeyframe(1, duration: 0.20)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.rightEye.closedOpacity) {
            LinearKeyframe(0, duration: 1.5)
            LinearKeyframe(0, duration: 0.08)
            LinearKeyframe(1, duration: 0.12)//1.7s passed
            LinearKeyframe(1, duration: 0.20)
            LinearKeyframe(0, duration: 0.12)
            LinearKeyframe(0, duration: 0.18)
        }
        
        // Left eyebrow
        KeyframeTrack(\StarFigure.StarViewConfiguration.leftEyebrow.scale) {
            LinearKeyframe(1, duration: 0.15)
            SpringKeyframe(1.3, duration: 0.2, spring: .smooth, startVelocity: 2)
            SpringKeyframe(1, duration: 0.5, spring: .bouncy(extraBounce: 0.2))
            LinearKeyframe(1, duration: 1.8)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.leftEyebrow.opacity) {
            LinearKeyframe(0, duration: 0.15)
            SpringKeyframe(1, duration: 0.2, spring: .smooth, startVelocity: 2)
            LinearKeyframe(1, duration: 1.85)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.leftEyebrow.frame.width) {
            let value = value.leftEyebrow.frame.width
            LinearKeyframe(value, duration: 1.5)
            LinearKeyframe(40/50 * value, duration: 0.2)
            LinearKeyframe(40/50 * value, duration: 0.2)
            LinearKeyframe(value, duration: 0.3)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.leftEyebrow.frame.height) {
            let value = value.leftEyebrow.frame.height
            LinearKeyframe(value, duration: 1.5)
            LinearKeyframe(15/20 * value, duration: 0.2)
            LinearKeyframe(15/20 * value, duration: 0.2)
            LinearKeyframe(value, duration: 0.3)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.leftEyebrow.rotation) {
            let value = value.leftEyebrow.rotation
            LinearKeyframe(value, duration: 1.5)
            LinearKeyframe(.degrees(30/20 * value.degrees), duration: 0.2)
            LinearKeyframe(.degrees(30/20 * value.degrees), duration: 0.2)
            LinearKeyframe(.degrees(value.degrees), duration: 0.3)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.leftEyebrow.offset.y) {
            let value = value.leftEyebrow.offset.y
            LinearKeyframe(value, duration: 1.5)
            LinearKeyframe(40/30 * value, duration: 0.2)
            LinearKeyframe(40/30 * value, duration: 0.2)
            LinearKeyframe(value, duration: 0.3)
        }
        
        // Right eyebrow
        KeyframeTrack(\StarFigure.StarViewConfiguration.rightEyebrow.scale) {
            LinearKeyframe(1, duration: 0.2)
            SpringKeyframe(1.31, duration: 0.2, spring: .smooth, startVelocity: 2)
            SpringKeyframe(1, duration: 0.5, spring: .bouncy(extraBounce: 0.2))
            LinearKeyframe(1, duration: 1.3)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.rightEyebrow.opacity) {
            LinearKeyframe(0, duration: 0.2)
            SpringKeyframe(1, duration: 0.2, spring: .smooth, startVelocity: 2)
            LinearKeyframe(1, duration: 1.8)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.rightEyebrow.frame.width) {
            let value = value.rightEyebrow.frame.width
            LinearKeyframe(value, duration: 1.5)
            LinearKeyframe(40/50 * value, duration: 0.2)
            LinearKeyframe(40/50 * value, duration: 0.2)
            LinearKeyframe(value, duration: 0.3)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.rightEyebrow.frame.height) {
            let value = value.rightEyebrow.frame.height
            LinearKeyframe(value, duration: 1.5)
            LinearKeyframe(15/20 * value, duration: 0.2)
            LinearKeyframe(15/20 * value, duration: 0.2)
            LinearKeyframe(value, duration: 0.3)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.rightEyebrow.rotation) {
            let value = value.rightEyebrow.rotation
            LinearKeyframe(value, duration: 1.5)
            LinearKeyframe(.degrees(15/20 * value.degrees), duration: 0.2)
            LinearKeyframe(.degrees(15/20 * value.degrees), duration: 0.2)
            LinearKeyframe(.degrees(value.degrees), duration: 0.3)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.rightEyebrow.offset.y) {
            let value = value.rightEyebrow.offset.y
            LinearKeyframe(value, duration: 1.5)
            LinearKeyframe(25/30 * value, duration: 0.2)
            LinearKeyframe(25/30 * value, duration: 0.2)
            LinearKeyframe(value, duration: 0.3)
        }
        
        // Mouth
        KeyframeTrack(\StarFigure.StarViewConfiguration.mouth.scale) {
            LinearKeyframe(1, duration: 0.3)
            SpringKeyframe(1.3, duration: 0.2, spring: .smooth, startVelocity: 2)
            SpringKeyframe(1, duration: 0.5, spring: .bouncy(extraBounce: 0.2))
            LinearKeyframe(1, duration: 1.2)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.mouth.opacity) {
            LinearKeyframe(0, duration: 0.3)
            SpringKeyframe(1, duration: 0.2, spring: .smooth, startVelocity: 2)
            LinearKeyframe(1, duration: 1.7)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.mouth.frame.height) {
            LinearKeyframe(50/300, duration: 0.5)
            SpringKeyframe(65/300, duration: 1, spring: .smooth(extraBounce: 0.1))
            LinearKeyframe(65/300, duration: 0.7)
        }
    }
}

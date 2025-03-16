//
//  Wink.swift
//  GoalPilot
//
//  Created by Rune Pollet on 22/05/2024.
//

import SwiftUI

extension StarFigure.StarView {
    /// Let's the star figure's expression wink.
    @KeyframesBuilder<StarFigure.StarViewConfiguration>
    static func winkKeyframes(_ value: StarFigure.StarViewConfiguration) -> some Keyframes<StarFigure.StarViewConfiguration> {
        // Left eye
        KeyframeTrack(\StarFigure.StarViewConfiguration.leftEye.frame.width) {
            let value = value.leftEye.frame.width
            LinearKeyframe(35/40 * value, duration: 0.2)
            LinearKeyframe(35/40 * value, duration: 0.2)
            LinearKeyframe(value, duration: 0.3)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.leftEye.frame.height) {
            let value = value.leftEye.frame.height
            LinearKeyframe(45/40 * value, duration: 0.2)
            LinearKeyframe(45/40 * value, duration: 0.2)
            LinearKeyframe(value, duration: 0.3)
        }
        
        // Right eye
        KeyframeTrack(\StarFigure.StarViewConfiguration.rightEye.eyeFrame.height) {
            let value = value.rightEye.eyeFrame.height
            LinearKeyframe(0.2/1 * value, duration: 0.10)
            LinearKeyframe(0.2/1 * value, duration: 0.40)
            LinearKeyframe(value, duration: 0.20)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.rightEye.opacity) {
            LinearKeyframe(0, duration: 0.10)
            LinearKeyframe(0, duration: 0.40)
            LinearKeyframe(1, duration: 0.20)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.rightEye.closedOpacity) {
            LinearKeyframe(0, duration: 0.08)
            LinearKeyframe(1, duration: 0.12)
            LinearKeyframe(1, duration: 0.20)
            LinearKeyframe(0, duration: 0.12)
            LinearKeyframe(0, duration: 0.18)
        }
        
        // Left eyebrow
        KeyframeTrack(\StarFigure.StarViewConfiguration.leftEyebrow.frame.width) {
            let value = value.leftEyebrow.frame.width
            LinearKeyframe(40/50 * value, duration: 0.2)
            LinearKeyframe(40/50 * value, duration: 0.2)
            LinearKeyframe(value, duration: 0.3)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.leftEyebrow.frame.height) {
            let value = value.leftEyebrow.frame.height
            LinearKeyframe(15/20 * value, duration: 0.2)
            LinearKeyframe(15/20 * value, duration: 0.2)
            LinearKeyframe(value, duration: 0.3)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.leftEyebrow.rotation) {
            let value = value.leftEyebrow.rotation
            LinearKeyframe(.degrees(30/20 * value.degrees), duration: 0.2)
            LinearKeyframe(.degrees(30/20 * value.degrees), duration: 0.2)
            LinearKeyframe(.degrees(value.degrees), duration: 0.3)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.leftEyebrow.offset.y) {
            let value = value.leftEyebrow.offset.y
            LinearKeyframe(40/30 * value, duration: 0.2)
            LinearKeyframe(40/30 * value, duration: 0.2)
            LinearKeyframe(value, duration: 0.3)
        }
        
        // Right eyebrow
        KeyframeTrack(\StarFigure.StarViewConfiguration.rightEyebrow.frame.width) {
            let value = value.rightEyebrow.frame.width
            LinearKeyframe(40/50 * value, duration: 0.2)
            LinearKeyframe(40/50 * value, duration: 0.2)
            LinearKeyframe(value, duration: 0.3)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.rightEyebrow.frame.height) {
            let value = value.rightEyebrow.frame.height
            LinearKeyframe(15/20 * value, duration: 0.2)
            LinearKeyframe(15/20 * value, duration: 0.2)
            LinearKeyframe(value, duration: 0.3)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.rightEyebrow.rotation) {
            let value = value.rightEyebrow.rotation
            LinearKeyframe(.degrees(15/20 * value.degrees), duration: 0.2)
            LinearKeyframe(.degrees(15/20 * value.degrees), duration: 0.2)
            LinearKeyframe(.degrees(value.degrees), duration: 0.3)
        }
        KeyframeTrack(\StarFigure.StarViewConfiguration.rightEyebrow.offset.y) {
            let value = value.rightEyebrow.offset.y
            LinearKeyframe(25/30 * value, duration: 0.2)
            LinearKeyframe(25/30 * value, duration: 0.2)
            LinearKeyframe(value, duration: 0.3)
        }
    }
}

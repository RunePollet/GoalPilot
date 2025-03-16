//
//  StarViewConfiguration.swift
//  GoalPilot
//
//  Created by Rune Pollet on 13/01/2024.
//

import SwiftUI

extension StarFigure {
    /// Describes a star figure.
    struct StarViewConfiguration {
        enum Character {
            case goal, milestone
        }
        
        var character: Self.Character
        var star: StarFigure.Star
        var leftEye: StarFigure.Eye
        var rightEye: StarFigure.Eye
        var leftEyebrow: StarFigure.Eyebrow
        var rightEyebrow: StarFigure.Eyebrow
        var mouth: StarFigure.Mouth
        
        init(character: Self.Character = .goal,
             star: StarFigure.Star = .init(),
             leftEye: StarFigure.Eye = .init(side: .left),
             rightEye: StarFigure.Eye = .init(side: .right),
             leftEyebrow: StarFigure.Eyebrow = .init(side: .left),
             rightEyebrow: StarFigure.Eyebrow = .init(side: .right),
             mouth: StarFigure.Mouth = .init()) {
            self.character = character
            self.star = star
            self.leftEye = leftEye
            self.rightEye = rightEye
            self.leftEyebrow = leftEyebrow
            self.rightEyebrow = rightEyebrow
            self.mouth = mouth
        }
    }
}

extension StarFigure.StarViewConfiguration: Equatable {
    static func == (lhs: StarFigure.StarViewConfiguration, rhs: StarFigure.StarViewConfiguration) -> Bool {
        return lhs.star == rhs.star && lhs.leftEye == rhs.leftEye && lhs.rightEye == rhs.rightEye && lhs.leftEyebrow == rhs.leftEyebrow && lhs.rightEyebrow == rhs.rightEyebrow && lhs.mouth == rhs.mouth
    }
}

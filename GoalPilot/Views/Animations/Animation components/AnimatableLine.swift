//
//  AnimatableLine.swift
//  GoalPilot
//
//  Created by Rune Pollet on 29/12/2024.
//

import SwiftUI

/// A path along which a line can be animated.
struct AnimatableLine<T: ShapeStyle>: View, Animatable {
    var path: Path
    var progress: CGFloat
    var strokeContent: T
    var strokeStyle: StrokeStyle
    var shadowColor: Color = .clear
    var shadowRadius: CGFloat = 0
    
    nonisolated var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    var body: some View {
        path.trimmedPath(from: 0, to: progress)
            .stroke(strokeContent, style: strokeStyle)
            .shadow(color: shadowColor, radius: shadowRadius)
    }
}

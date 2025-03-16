//
//  DrawedShape.swift
//  GoalPilot
//
//  Created by Rune Pollet on 09/12/2024.
//

import SwiftUI

/// A shape which exposes its available with and height to draw a path.
struct DrawedShape: Shape {
    var draw: @Sendable (_ path: inout Path, _ width: CGFloat, _ height: CGFloat) -> Void
    func path(in rect: CGRect) -> Path {
        var path = Path()
        draw(&path, rect.width, rect.height)
        return path
    }
}

//
//  StarShapeView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 28/12/2023.
//

import SwiftUI

extension StarFigure {
    /// The view of a star shape in the star figure.
    struct StarShapeView: View {
        var geo: GeometryProxy
        var star: Star
        
        var body: some View {
            StarShape()
                .rotationEffect(star.rotation)
                .scaleEffect(star.scale)
                .offset(x: geo.size.width*star.offset.width, y: geo.size.height*star.offset.height)
        }
    }
    
    struct StarShape: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let minDimension = rect.size.minDimension
            let origin = rect.origin
            path.move(to: CGPoint(x: 0.44762*minDimension, y: 0.03981*minDimension))
            path.addCurve(to: CGPoint(x: 0.55238*minDimension, y: 0.03981*minDimension), control1: CGPoint(x: 0.46741*minDimension, y: -0.00836*minDimension), control2: CGPoint(x: 0.53259*minDimension, y: -0.00836*minDimension))
            path.addLine(to: CGPoint(x: 0.65058*minDimension, y: 0.27873*minDimension))
            path.addCurve(to: CGPoint(x: 0.6977*minDimension, y: 0.3146*minDimension), control1: CGPoint(x: 0.65884*minDimension, y: 0.29882*minDimension), control2: CGPoint(x: 0.67691*minDimension, y: 0.31258*minDimension))
            path.addLine(to: CGPoint(x: 0.94491*minDimension, y: 0.33863*minDimension))
            path.addCurve(to: CGPoint(x: 0.97728*minDimension, y: 0.44303*minDimension), control1: CGPoint(x: 0.99474*minDimension, y: 0.34347*minDimension), control2: CGPoint(x: 1.01488*minDimension, y: 0.40842*minDimension))
            path.addLine(to: CGPoint(x: 0.79076*minDimension, y: 0.61472*minDimension))
            path.addCurve(to: CGPoint(x: 0.77276*minDimension, y: 0.67275*minDimension), control1: CGPoint(x: 0.77508*minDimension, y: 0.62916*minDimension), control2: CGPoint(x: 0.76817*minDimension, y: 0.65141*minDimension))
            path.addLine(to: CGPoint(x: 0.82735*minDimension, y: 0.92653*minDimension))
            path.addCurve(to: CGPoint(x: 0.74259*minDimension, y: 0.99106*minDimension), control1: CGPoint(x: 0.83836*minDimension, y: 0.97769*minDimension), control2: CGPoint(x: 0.78563*minDimension, y: 1.01783*minDimension))
            path.addLine(to: CGPoint(x: 0.52912*minDimension, y: 0.85824*minDimension))
            path.addCurve(to: CGPoint(x: 0.47088*minDimension, y: 0.85824*minDimension), control1: CGPoint(x: 0.51117*minDimension, y: 0.84707*minDimension), control2: CGPoint(x: 0.48883*minDimension, y: 0.84707*minDimension))
            path.addLine(to: CGPoint(x: 0.25741*minDimension, y: 0.99106*minDimension))
            path.addCurve(to: CGPoint(x: 0.17265*minDimension, y: 0.92653*minDimension), control1: CGPoint(x: 0.21437*minDimension, y: 1.01783*minDimension), control2: CGPoint(x: 0.16164*minDimension, y: 0.97769*minDimension))
            path.addLine(to: CGPoint(x: 0.22723*minDimension, y: 0.67275*minDimension))
            path.addCurve(to: CGPoint(x: 0.20924*minDimension, y: 0.61472*minDimension), control1: CGPoint(x: 0.23182*minDimension, y: 0.65141*minDimension), control2: CGPoint(x: 0.22492*minDimension, y: 0.62916*minDimension))
            path.addLine(to: CGPoint(x: 0.02272*minDimension, y: 0.44303*minDimension))
            path.addCurve(to: CGPoint(x: 0.05509*minDimension, y: 0.33863*minDimension), control1: CGPoint(x: -0.01488*minDimension, y: 0.40842*minDimension), control2: CGPoint(x: 0.00526*minDimension, y: 0.34347*minDimension))
            path.addLine(to: CGPoint(x: 0.3023*minDimension, y: 0.3146*minDimension))
            path.addCurve(to: CGPoint(x: 0.34942*minDimension, y: 0.27873*minDimension), control1: CGPoint(x: 0.32309*minDimension, y: 0.31258*minDimension), control2: CGPoint(x: 0.34116*minDimension, y: 0.29882*minDimension))
            path.addLine(to: CGPoint(x: 0.44762*minDimension, y: 0.03981*minDimension))
            path.closeSubpath()
            return path.offsetBy(dx: origin.x, dy: origin.y)
        }
    }
}

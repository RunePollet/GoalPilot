//
//  BelieveInYourselfIcon.swift
//  GoalPilot
//
//  Created by Rune Pollet on 21/08/2024.
//

import SwiftUI

/// An icon which can be used along a text which message is to believe in yourself.
struct BelieveInYourselfIcon: View {
    var showHeart: Bool
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Person()
                    .stroke(style: StrokeStyle(lineWidth: geo.size.minDimension*0.05))
                    .frame(width: geo.size.width, height: geo.size.width*(1583.46/1194.23))
                    .foregroundStyle(.secondary)
                if showHeart {
                    Circle()
                        .frame(width: geo.size.minDimension*0.2)
                        .offset(y: geo.size.minDimension*0.3)
                        .shadow(radius: 5)
                    Circle()
                        .frame(width: geo.size.minDimension*0.8)
                        .offset(y: geo.size.minDimension*0.3)
                        .blur(radius: geo.size.minDimension*0.3)
                }
            }
        }
    }
}

private struct Person: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.49945*width, y: 0.45615*height))
        path.addCurve(to: CGPoint(x: 0.99936*width, y: 0.73336*height), control1: CGPoint(x: 0.80932*width, y: 0.45615*height), control2: CGPoint(x: 0.99936*width, y: 0.61957*height))
        path.addCurve(to: CGPoint(x: 0.99936*width, y: 0.93371*height), control1: CGPoint(x: 0.99936*width, y: 0.73343*height), control2: CGPoint(x: 0.99936*width, y: 0.93364*height))
        path.addCurve(to: CGPoint(x: 0.86834*width, y: 0.99966*height), control1: CGPoint(x: 0.99921*width, y: 0.97879*height), control2: CGPoint(x: 0.95717*width, y: 0.99966*height))
        path.addLine(to: CGPoint(x: 0.49968*width, y: 0.99966*height))
        path.addLine(to: CGPoint(x: 0.13101*width, y: 0.99966*height))
        path.addCurve(to: CGPoint(x: 0.00001*width, y: 0.93434*height), control1: CGPoint(x: 0.0426*width, y: 0.99966*height), control2: CGPoint(x: 0.00054*width, y: 0.97899*height))
        path.addCurve(to: CGPoint(x: 0, y: 0.73336*height), control1: CGPoint(x: 0, y: 0.93406*height), control2: CGPoint(x: 0, y: 0.73364*height))
        path.addCurve(to: CGPoint(x: 0.49945*width, y: 0.45615*height), control1: CGPoint(x: 0, y: 0.61957*height), control2: CGPoint(x: 0.19003*width, y: 0.45615*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.74493*width, y: 0.19684*height))
        path.addCurve(to: CGPoint(x: 0.50035*width, y: 0.39875*height), control1: CGPoint(x: 0.74493*width, y: 0.3086*height), control2: CGPoint(x: 0.63583*width, y: 0.39875*height))
        path.addCurve(to: CGPoint(x: 0.25532*width, y: 0.19752*height), control1: CGPoint(x: 0.36487*width, y: 0.39875*height), control2: CGPoint(x: 0.25532*width, y: 0.30894*height))
        path.addCurve(to: CGPoint(x: 0.50035*width, y: 0), control1: CGPoint(x: 0.25532*width, y: 0.08846*height), control2: CGPoint(x: 0.36531*width, y: 0))
        path.addCurve(to: CGPoint(x: 0.74493*width, y: 0.19684*height), control1: CGPoint(x: 0.63583*width, y: 0), control2: CGPoint(x: 0.74493*width, y: 0.08711*height))
        path.closeSubpath()
        return path
    }
}

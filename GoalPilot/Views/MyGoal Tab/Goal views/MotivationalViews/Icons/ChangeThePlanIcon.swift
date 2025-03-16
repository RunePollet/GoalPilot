//
//  ChangeThePlanIcon.swift
//  GoalPilot
//
//  Created by Rune Pollet on 20/08/2024.
//

import SwiftUI

/// An icon which can be used along a text which message is that there are many ways to one destination.
struct ChangeThePlanIcon: View {
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                // Goal
                StarFigure.StarShape()
                    .foregroundStyle(Color(AssetsCatalog.goalColorID))
                    .frame(width: geo.size.minDimension*0.15)
                    .offset(x: geo.size.width*1.05, y: -geo.size.width*0.15)
                
                // Other paths
                Path { path in
                    let width = geo.size.width
                    let height = geo.size.height
                    path.move(to: CGPoint(x: 0.00219*width, y: 0.99871*height))
                    path.addCurve(to: CGPoint(x: 0.13756*width, y: 0.42397*height), control1: CGPoint(x: 0.00219*width, y: 0.99871*height), control2: CGPoint(x: 0.00219*width, y: 0.6134*height))
                    path.addCurve(to: CGPoint(x: 0.45852*width, y: 0.28479*height), control1: CGPoint(x: 0.24306*width, y: 0.27633*height), control2: CGPoint(x: 0.3595*width, y: 0.36912*height))
                    path.addCurve(to: CGPoint(x: 0.62337*width, y: 0.04381*height), control1: CGPoint(x: 0.55764*width, y: 0.20038*height), control2: CGPoint(x: 0.52385*width, y: 0.12758*height))
                    path.addCurve(to: CGPoint(x: width, y: 0), control1: CGPoint(x: 0.73314*width, y: -0.04859*height), control2: CGPoint(x: 0.99782*width, y: 0))
                }
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [8, 15]))
                .foregroundStyle(.secondary)
                Path { path in
                    let width = geo.size.width
                    let height = geo.size.height
                    path.move(to: CGPoint(x: 0.00032*width, y: 0.98343*height))
                    path.addCurve(to: CGPoint(x: 0.66012*width, y: 0.75828*height), control1: CGPoint(x: 0.00032*width, y: 0.98343*height), control2: CGPoint(x: 0.49277*width, y: 1.08997*height))
                    path.addCurve(to: CGPoint(x: 0.8105*width, y: 0.37329*height), control1: CGPoint(x: 0.71669*width, y: 0.64618*height), control2: CGPoint(x: 0.67465*width, y: 0.51619*height))
                    path.addCurve(to: CGPoint(x: 0.99968*width, y: 0), control1: CGPoint(x: 0.94636*width, y: 0.2304*height), control2: CGPoint(x: 0.99968*width, y: 0.24893*height))
                }
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [8, 15]))
                .foregroundStyle(.secondary)
                
                // Arrow
                Path { path in
                    let width = geo.size.width
                    let height = geo.size.height
                    path.move(to: CGPoint(x: 0, y: 0.99941*height))
                    path.addCurve(to: CGPoint(x: 0.48036*width, y: 0.66851*height), control1: CGPoint(x: 0, y: 0.99941*height), control2: CGPoint(x: 0.31295*width, y: 1.00546*height))
                    path.addCurve(to: CGPoint(x: 0.66001*width, y: 0.27129*height), control1: CGPoint(x: 0.53694*width, y: 0.55463*height), control2: CGPoint(x: 0.52411*width, y: 0.41645*height))
                    path.addCurve(to: CGPoint(x: 0.99968*width, y: 0.0004*height), control1: CGPoint(x: 0.79591*width, y: 0.12613*height), control2: CGPoint(x: 0.85899*width, y: 0.12079*height))
                }
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                Path { path in
                    let width = geo.size.width
                    path.move(to: CGPoint(x: width, y: 0))
                    path.addLine(to: CGPoint(x: width*0.95, y: 0))
                }
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                Path { path in
                    let width = geo.size.width
                    let height = geo.size.height
                    path.move(to: CGPoint(x: width, y: 0))
                    path.addLine(to: CGPoint(x: width, y: height*0.05))
                }
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                
                // Start
                Circle()
                    .frame(width: geo.size.minDimension*0.06)
                    .offset(x: -geo.size.minDimension*0.025, y: geo.size.minDimension*0.025)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            }
        }
    }
}

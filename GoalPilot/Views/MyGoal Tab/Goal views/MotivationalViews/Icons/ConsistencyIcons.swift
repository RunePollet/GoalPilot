//
//  ConsistencyIcons.swift
//  GoalPilot
//
//  Created by Rune Pollet on 19/08/2024.
//

import SwiftUI

/// An icon which can be used along a text which message is that consistency goas a long way.
struct ConsistencyIcon: View {
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            ZStack {
                XAxis()
                    .stroke(lineWidth: 2)
                    .foregroundStyle(.secondary)
                Graph()
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                Text("Consistency")
                    .position(x: width*0.50, y: height+15)
            }
        }
    }
    
    private struct Graph: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.width
            let height = rect.height
            
            path.move(to: CGPoint(x: 0, y: height))
            path.addCurve(to: CGPoint(x: width*0.2, y: height), control1: CGPoint(x: width*0.05, y: height*0.85), control2: CGPoint(x: width*0.15, y: height*0.85))
            path.addCurve(to: CGPoint(x: width*0.4, y: height), control1: CGPoint(x: width*0.25, y: height*0.85), control2: CGPoint(x: width*0.35, y: height*0.85))
            path.addCurve(to: CGPoint(x: width*0.6, y: height), control1: CGPoint(x: width*0.45, y: height*0.85), control2: CGPoint(x: width*0.55, y: height*0.85))
            path.addCurve(to: CGPoint(x: width*0.8, y: height), control1: CGPoint(x: width*0.65, y: height*0.85), control2: CGPoint(x: width*0.75, y: height*0.85))
            path.addCurve(to: CGPoint(x: width, y: height), control1: CGPoint(x: width*0.85, y: height*0.85), control2: CGPoint(x: width*0.95, y: height*0.85))
            return path
        }
    }
}

/// An icon which can be used along a text which message is that motivation as only drive is temporary.
struct MotivationIcon: View {
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            ZStack {
                XAxis()
                    .stroke(lineWidth: 2)
                    .foregroundStyle(.secondary)
                Graph()
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                Text("Motivation")
                    .position(x: width*0.50, y: height+15)
            }
        }
    }
    
    private struct Graph: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.width
            let height = rect.height
            
            path.move(to: CGPoint(x: 0, y: height))
            path.addCurve(to: CGPoint(x: width*0.3, y: height), control1: CGPoint(x: width*0.05, y: height*0.65), control2: CGPoint(x: width*0.25, y: height*0.65))
            path.addCurve(to: CGPoint(x: width*0.5, y: height), control1: CGPoint(x: width*0.30, y: height*0.75), control2: CGPoint(x: width*0.50, y: height*0.75))
            path.addCurve(to: CGPoint(x: width*0.7, y: height), control1: CGPoint(x: width*0.55, y: height*0.85), control2: CGPoint(x: width*0.65, y: height*0.85))
            path.addCurve(to: CGPoint(x: width*0.8, y: height), control1: CGPoint(x: width*0.725, y: height*0.95), control2: CGPoint(x: width*0.775, y: height*0.95))
            return path
        }
    }
}

private struct XAxis: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: width, y: height))
        return path
    }
}

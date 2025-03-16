//
//  FailureToSuccessIcon.swift
//  GoalPilot
//
//  Created by Rune Pollet on 19/08/2024.
//

import SwiftUI

/// An icon which can be used along a text which message is that success comes from failure.
struct SuccessThroughFailureIcon: View {
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            ZStack {
                Axes()
                    .stroke(lineWidth: 2)
                    .foregroundStyle(.secondary)
                Graph()
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                Group {
                    Text("Fail")
                        .position(x: width*0.20, y: (height*0.64)-10)
                    Text("Learn")
                        .position(x: width*0.32, y: (height*0.80)+10)
                    Text("Fail")
                        .position(x: width*0.52, y: (height*0.44)-10)
                    Text("Learn")
                        .position(x: width*0.64, y: (height*0.60)+10)
                }
                .foregroundStyle(.primary)
                Group {
                    Text("Success")
                        .rotationEffect(.degrees(-90))
                        .position(x: -15, y: height*0.2)
                    Text("Time")
                        .position(x: width*0.9, y: height+15)
                }
                .foregroundStyle(.secondary)
            }
        }
    }
    
    private struct Graph: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.width
            let height = rect.height
            
            path.move(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: width*0.20, y: height*0.64))
            path.addLine(to: CGPoint(x: width*0.32, y: height*0.80))
            path.addLine(to: CGPoint(x: width*0.52, y: height*0.44))
            path.addLine(to: CGPoint(x: width*0.64, y: height*0.60))
            path.addLine(to: CGPoint(x: width*0.96, y: 0))
            return path
        }
    }
}

/// An icon which can be used along a text which message is that failure without action isn't good.
struct FailureIcon: View {
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            ZStack {
                Axes()
                    .stroke(lineWidth: 2)
                    .foregroundStyle(.secondary)
                Graph()
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                Text("Fail")
                    .position(x: width*0.25, y: (height*0.50)-10)
                Text("Give up")
                    .position(x: (width*0.5)+20, y: height-15)
                Group {
                    Text("Success")
                        .rotationEffect(.degrees(-90))
                        .position(x: -15, y: height*0.2)
                    Text("Time")
                        .position(x: width*0.9, y: height+15)
                }
                .foregroundStyle(HierarchicalShapeStyle.secondary)
            }
        }
    }
    
    private struct Graph: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.width
            let height = rect.height
            
            path.move(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: width*0.25, y: height*0.50))
            path.addLine(to: CGPoint(x: width*0.50, y: height))
            path.addLine(to: CGPoint(x: width, y: height))
            return path
        }
    }
}

private struct Axes: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: width, y: height))
        return path
    }
}

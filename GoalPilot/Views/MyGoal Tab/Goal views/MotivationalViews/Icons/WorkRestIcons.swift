//
//  WorkRestIcons.swift
//  GoalPilot
//
//  Created by Rune Pollet on 18/08/2024.
//

import SwiftUI

/// An icon which can be used along a text which message is that rest is needed in order to keep going.
struct WorkRestIcon: View {
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let bandWidth: Double = 15/300 * geo.size.width
            let circleWidth: Double = geo.size.width/6
            let bandPadding: Double = (circleWidth/2) - (bandWidth/2)
            
            ZStack {
                // Band
                Circle()
                    .stroke(lineWidth: bandWidth)
                    .padding(bandWidth/2)
                    .padding(bandPadding)
                    .foregroundStyle(.secondary)
                
                // Circles
                CircleComponent(width: circleWidth, alignment: .top, outerGeo: geo)
                CircleComponent(width: circleWidth, alignment: .trailing, outerGeo: geo)
                CircleComponent(width: circleWidth, alignment: .bottom, outerGeo: geo)
                CircleComponent(width: circleWidth, alignment: .leading, outerGeo: geo)
                
                // Text
                Text("Work")
                    .position(x: width*0.5, y: -15)
                Text("Work")
                    .position(x: width*0.5, y: height+15)
                Text("Rest")
                    .position(x: -25, y: height*0.5)
                Text("Rest")
                    .position(x: width+25, y: height*0.5)
            }
        }
    }
}

/// An icon which can be used along a text which message is that without rest, you might have burnout.
struct BurnOutIcon: View {
    var background: Color
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let bandWidth: Double = 15/300 * geo.size.width
            let circleWidth: Double = geo.size.width/6
            let bandPadding: Double = (circleWidth/2) - (bandWidth/2)
            
            ZStack {
                // Band
                Circle()
                    .stroke(lineWidth: bandWidth)
                    .padding(bandWidth/2)
                    .padding(bandPadding)
                    .foregroundStyle(.secondary)
                
                // Circles
                CircleComponent(width: circleWidth, alignment: .top, outerGeo: geo, invisible: true, background: background)
                CircleComponent(width: circleWidth, alignment: .trailing, outerGeo: geo)
                CircleComponent(width: circleWidth, alignment: .bottom, outerGeo: geo)
                CircleComponent(width: circleWidth, alignment: .leading, outerGeo: geo)
                
                // Text
                Text("Burn out")
                    .position(x: width*0.5, y: -10)
                Text("Work")
                    .position(x: width*0.5, y: height+15)
                Text("Work")
                    .position(x: -25, y: height*0.5)
                Text("Work")
                    .position(x: width+25, y: height*0.5)
            }
        }
    }
}

private struct CircleComponent: View {
    var width: Double
    var alignment: Alignment
    var outerGeo: GeometryProxy
    var invisible: Bool
    var background: Color?
    
    init(width: Double, alignment: Alignment, outerGeo: GeometryProxy, invisible: Bool = false, background: Color? = nil) {
        self.width = width
        self.alignment = alignment
        self.outerGeo = outerGeo
        self.invisible = invisible
        self.background = background
    }
    
    @State private var circleFrame: CGRect = .zero
    
    var body: some View {
        Group {
            if invisible, let background {
                Rectangle()
                    .foregroundStyle(background)
            } else {
                Circle()
            }
        }
        .frame(width: width, height: width)
        .readFrame(initialOnly: true) { frame in
            circleFrame = frame
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
}

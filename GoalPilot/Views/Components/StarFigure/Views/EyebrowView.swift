//
//  EyebrowView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 28/12/2023.
//

import SwiftUI

extension StarFigure {
    /// The view of an eyebrow in the star figure.
    struct EyebrowView: View {
        var geo: GeometryProxy
        var eyebrow: Eyebrow
        
        init(geo: GeometryProxy, eyebrow: Eyebrow) {
            self.geo = geo
            self.eyebrow = eyebrow
        }
        
        init(geo: GeometryProxy, side: Side) {
            self.geo = geo
            self.eyebrow = Eyebrow(side: side)
        }
        
        var body: some View {
            ZStack {
                EyebrowShape()
                    .stroke(.secondary, style: StrokeStyle(lineWidth: geo.size.maxDimension*(12/300), lineCap: .round))
            }
            .frame(width: geo.size.width * (eyebrow.frame.width),
                   height: geo.size.height * (eyebrow.frame.height))
            .offset(x: geo.size.width * eyebrow.offset.x,
                    y: geo.size.height * eyebrow.offset.y)
            .rotationEffect(eyebrow.rotation, anchor: eyebrow.rotationAnchor)
            .scaleEffect(eyebrow.scale, anchor: eyebrow.scaleAnchor)
            .opacity(eyebrow.opacity)
        }
    }
    
    private struct EyebrowShape: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.size.width
            let height = rect.size.height
            
            let startPoint = CGPoint(x: 0, y: height * 0.50)
            
            path.move(to: startPoint)
            path.addCurve(to: CGPoint(x: width, y: height * 0.50),
                          control1: CGPoint(x: width * 0.30, y: 0),
                          control2: CGPoint(x: width * 0.70, y: 0))
            
            return path
        }
    }
}

//
//  MouthView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 28/12/2023.
//

import SwiftUI

extension StarFigure {
    /// The view of a mouth in the star figure.
    struct MouthView: View {
        var geo: GeometryProxy
        var mouth: Mouth
        
        init(geo: GeometryProxy, mouth: Mouth) {
            self.geo = geo
            self.mouth = mouth
        }
        
        init(geo: GeometryProxy) {
            self.geo = geo
            self.mouth = Mouth()
        }
        
        private var smallestDimension: CGFloat {
            return geo.size.width > geo.size.height ? geo.size.height : geo.size.width
        }
        
        var body: some View {
            Color.white
                .mask {
                    MouthShape()
                        .stroke(.white, style: StrokeStyle(lineWidth: smallestDimension*(12/300), lineCap: .round, lineJoin: .round))
                        .fill(.white)
                        .scaleEffect(y: mouth.flip ? -1 : 1)
                        .frame(width: geo.size.width * mouth.frame.width, height: geo.size.height * mouth.frame.height)
                }
                .offset(y: geo.size.height * (50/300))
                .frame(width: (geo.size.width * mouth.frame.width) + (smallestDimension*(14/300)), height: geo.size.height * mouth.frame.height)
                .opacity(mouth.opacity)
        }
    }
    
    private struct MouthShape: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.size.width
            let height = rect.size.height
            
            let startPoint = CGPoint(x: 0, y: (height * 0.50))
            
            path.move(to: startPoint)
            path.addCurve(to: CGPoint(x: width, y: height * 0.50),
                          control1: CGPoint(x: width * 0.4, y: height),
                          control2: CGPoint(x: width * 0.6, y: height))
            path.addCurve(to: startPoint,
                          control1: CGPoint(x: width * 0.6, y: height * 0.75),
                          control2: CGPoint(x: width * 0.4, y: height * 0.75))
            path.closeSubpath()
            
            return path
        }
    }
}

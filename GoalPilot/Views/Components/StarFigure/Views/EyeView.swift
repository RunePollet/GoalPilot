//
//  EyeView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 28/12/2023.
//

import SwiftUI

extension StarFigure {
    /// The view of an eye in the star figure.
    struct EyeView: View {
        var geo: GeometryProxy
        var eye: Eye
        @Namespace private var namespace
        
        init(geo: GeometryProxy, eye: Eye) {
            self.geo = geo
            self.eye = eye
        }
        
        init(geo: GeometryProxy, side: Side) {
            self.geo = geo
            self.eye = Eye(side: side)
        }
        
        var pupilFrame: (width: CGFloat, height: CGFloat) {
            if eye.keepPupilSymmetry {
                
                if eye.pupilFrame.width > eye.pupilFrame.height {
                    
                    return (eye.pupilFrame.width, eye.pupilFrame.width)
                }
                return (eye.pupilFrame.height, eye.pupilFrame.height)
            }
            return (eye.pupilFrame.width, eye.pupilFrame.height)
        }
        
        var body: some View {
            GeometryReader { localGeo in
                ZStack {
                    if eye.closed {
                        Rectangle()
                            .foregroundStyle(.secondary)
                            .mask(
                                closedEyeMask(localGeo)
                                    .rotation3DEffect(.degrees(eye.hFlip ? 180 : 0), axis: (0, 1, 0))
                            )
                            .frame(width: localGeo.size.width * eye.closedFrame.width,
                                   height: localGeo.size.height * eye.closedFrame.height)
                            .opacity(eye.closedOpacity)
                    }
                    
                    if eye.open {
                        ZStack {
                            Ellipse()
                                .foregroundStyle(Color.white)
                            Ellipse()
                                .frame(width: correctGeoSize(localGeo.size.width, localGeo.size.height) * self.pupilFrame.width,
                                       height: correctGeoSize(localGeo.size.height, localGeo.size.width) * self.pupilFrame.height)
                                .offset(x: localGeo.size.width * eye.pupilOffset.x,
                                        y: localGeo.size.height * eye.pupilOffset.y)
                                .foregroundStyle(.secondary)
                        }
                        .frame(width: localGeo.size.width * eye.eyeFrame.width,
                               height: localGeo.size.height * eye.eyeFrame.height)
                        .opacity(eye.opacity)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: (geo.size.width * eye.frame.width),
                   height: geo.size.height * eye.frame.height)
        }
        
        private func closedEyeMask(_ geo: GeometryProxy) -> some View {
            ClosedEyeShape()
                .stroke(style: StrokeStyle(lineWidth: self.geo.size.maxDimension*(10/300), lineCap: .round, lineJoin: .round))
                .frame(width: geo.size.width * eye.closedFrame.width - margin(),
                       height: geo.size.height * eye.closedFrame.height)
                .scaleEffect(eye.scale, anchor: eye.scaleAnchor)
        }
        
        /// Returns the biggest given number if pupil symmetry should be kept, otherwise returns the first number
        func correctGeoSize(_ fn: CGFloat, _ sn: CGFloat) -> CGFloat {
            if eye.keepPupilSymmetry {
                if fn > sn {
                    return fn
                }
                return sn
            }
            return fn
        }
        
        func margin() -> CGFloat {
            switch eye.closed {
            case true:
                return self.geo.size.minDimension * (20/300)
            case false:
                return 0
            }
        }
    }
    
    private struct ClosedEyeShape: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.width
            let height = rect.height
            
            path.move(to: CGPoint(x: width*0, y: height*0.5))
            path.addCurve(to: CGPoint(x: width*1, y: height*0.55),
                          control1: CGPoint(x: width*0.80, y: height*0.35),
                          control2: CGPoint(x: width*1, y: height*0.50))
            path.addCurve(to: CGPoint(x: width*0, y: height*0.5),
                          control1: CGPoint(x: width*0.75, y: height*0.50),
                          control2: CGPoint(x: width*0.70, y: height*0.45))
            path.closeSubpath()
            return path
        }
    }
}

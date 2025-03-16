//
//  TabBarBackgroundHill.swift
//  GoalPilot
//
//  Created by Rune Pollet on 07/12/2024.
//

import SwiftUI

extension Landscape {
    /// A hill suitable as background for the tab bar.
    struct TabBarBackgroundHill: View {
        var body: some View {
            GeometryReader { geo in
                TabBarBackgroundHillShape()
                    .foregroundStyle(Color(AssetsCatalog.secondHillColorID))
                    .frame(height: geo.size.width * 125/393)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
    
    private struct TabBarBackgroundHillShape: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.size.width
            let height = rect.size.height
            path.move(to: CGPoint(x: 1.00254*width, y: height))
            path.addLine(to: CGPoint(x: -0.00127*width, y: height))
            path.addLine(to: CGPoint(x: -0.00127*width, y: 0.556*height))
            path.addCurve(to: CGPoint(x: 0.4832*width, y: 0.32935*height), control1: CGPoint(x: -0.00127*width, y: 0.556*height), control2: CGPoint(x: 0.17171*width, y: 0.23117*height))
            path.addCurve(to: CGPoint(x: 0.93028*width, y: 0.1984*height), control1: CGPoint(x: 0.79469*width, y: 0.42753*height), control2: CGPoint(x: 0.89822*width, y: 0.268*height))
            path.addCurve(to: CGPoint(x: 1.00127*width, y: 0.0001*height), control1: CGPoint(x: 0.96234*width, y: 0.12881*height), control2: CGPoint(x: 0.97164*width, y: -0.00327*height))
            path.addCurve(to: CGPoint(x: 1.00254*width, y: 0.00029*height), control1: CGPoint(x: 1.00169*width, y: 0.00014*height), control2: CGPoint(x: 1.00212*width, y: 0.00021*height))
            path.addLine(to: CGPoint(x: 1.00254*width, y: height))
            path.closeSubpath()
            return path
        }
    }
}

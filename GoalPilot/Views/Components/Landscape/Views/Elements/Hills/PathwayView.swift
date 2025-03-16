//
//  PathwayView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 27/02/2024.
//

import SwiftUI

extension Landscape {
    /// The view representation of 'Pathway' model.
    struct PathwayView: View {
        enum Style {
            case todo, focused, reached
        }
        
        var pathway: Pathway
        var style: Self.Style
        var glow: Bool
        
        init(_ pathway: Pathway, style: Self.Style, glow: Bool) {
            self.pathway = pathway
            self.style = style
            self.glow = glow
        }
        
        var body: some View {
            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height
                let rect = CGRect(x: width*pathway.frame.minX, y: height*pathway.frame.minY, width: width*pathway.frame.width, height: height*pathway.frame.height)
                let magnitude = sqrt(width*width + height*height)
                
                ZStack {
                    pathway.path(rect.width, rect.height)
                        .stroke(style != .todo ? Color.accentColor : Color.accentColor.opacity(0.6), style: pathway.stroke(magnitude, false))
                        .shadow(color: style != .todo && glow ? Color.accentColor.opacity(0.6) : Color.clear, radius: 5)
                    AnimatableLine(path: pathway.path(rect.width, rect.height),
                                   progress: style == .reached ? 1 : 0,
                                   strokeContent: Color.accentColor,
                                   strokeStyle: pathway.stroke(magnitude, true),
                                   shadowColor: style != .todo && glow ? Color.accentColor.opacity(0.6) : Color.clear,
                                   shadowRadius: 5)
                }
                .frame(width: rect.width, height: rect.height)
                .offset(x: rect.origin.x, y: rect.origin.y)
            }
        }
    }
}

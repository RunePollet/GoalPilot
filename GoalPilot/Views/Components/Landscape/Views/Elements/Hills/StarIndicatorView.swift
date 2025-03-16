//
//  StarIndicatorView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 04/03/2024.
//

import SwiftUI

extension Landscape {
    /// The view representation of a star indicator.
    struct StarIndicatorView: View {
        
        var star: StarIndicator
        var number: Int
        var reached: Bool
        var glow: Bool
        
        init(_ star: StarIndicator, number: Int, reached: Bool, glow: Bool) {
            self.star = star
            self.number = number
            self.reached = reached
            self.glow = glow
        }
        
        var fontSize: CGFloat {
            return (number > 9 ? 9 : 13)
        }
        
        var body: some View {
            GeometryReader { geo in
                let size = geo.size
                let dimension = geo.size.width * 23/393
                var scale: CGFloat {
                    let refMagnitude = sqrt(393*393 + 292*292)
                    let actMagnitude = sqrt(size.width*size.width + size.height*size.height)
                    return refMagnitude/actMagnitude
                }
                
                ZStack {
                    // Star
                    StarFigure.StarShape()
                        .fill(reached ? Color.accentColor : Color.accentColor.opacity(0.6))
                        .shadow(color: reached && glow ? Color.accentColor.opacity(0.6) : Color.clear, radius: 5)
                    
                    // Number
                    Text(String(number))
                        .font(.milestoneOrderIndexBold(size: fontSize*scale))
                        .foregroundStyle(star.backgroundColor)
                        .offset(y: 1.4*scale)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipShape(StarFigure.StarShape())
                }
                .frame(width: dimension, height: dimension)
                .anchorPreference(key: StarIndicatorBounds.self, value: .bounds) { anchor in
                    [star.id.uuidString: anchor]
                }
                .offset(x: size.width*star.origin.x, y: size.height*star.origin.y)
            }
        }
    }
    
    struct StarIndicatorBounds: PreferenceKey {
        static let defaultValue: [String: Anchor<CGRect>] = [:]
        static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
            for (key, bounds) in nextValue() {
                value[key] = bounds
            }
        }
    }
}

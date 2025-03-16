//
//  Sunset.swift
//  GoalPilot
//
//  Created by Rune Pollet on 24/11/2024.
//

import SwiftUI

extension Landscape {
    /// A sky that represents sunset.
    struct Sunset: View {
        var body: some View {
            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height
                
                ZStack {
                    Sun(color: .orange)
                        .frame(width: width * 377/924, height: width * 377/924)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        .offset(x: width * -40/393, y: height * -10/852)
                        .clipped()
                    
                    ForEach(0..<3) { i in
                        var size: CGFloat {
                            if i == 0 {
                                return 5.0
                            } else {
                                return 3.0
                            }
                        }
                        var offset: CGSize {
                            if i == 0 {
                                return .init(width: width * 0.78, height: 0)
                            } else if i == 1 {
                                return .init(width: width * 0.85, height: height * 0.09)
                            } else {
                                return .init(width: width * 0.25, height: height * 0.07)
                            }
                        }
                        
                        Circle()
                            .foregroundStyle(Color.accentColor)
                            .frame(width: size)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .offset(offset)
                    }
                }
            }
        }
    }
}

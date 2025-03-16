//
//  Night.swift
//  GoalPilot
//
//  Created by Rune Pollet on 24/11/2024.
//

import SwiftUI

extension Landscape {
    /// A sky that represents nighttime.
    struct Night: View {
        var body: some View {
            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height
                
                ZStack {
                    Image(systemName: "moon.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width * 0.1)
                        .rotation3DEffect(.degrees(180), axis: (0, 1, 0))
                        .foregroundStyle(.yellow)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .offset(x: width * 0.7, y: width * 0.13)
                    
                    ForEach(0..<8) { i in
                        var size: CGFloat {
                            if i <= 2 {
                                return 5.0
                            } else {
                                return 3.0
                            }
                        }
                        var offset: CGSize {
                            switch i {
                            case 0:
                                return .init(width: width * 0.78, height: 0)
                            case 1:
                                return .init(width: width * 0.47, height: height * 0.11)
                            case 2:
                                return .init(width: width * 0.05, height: height * 0.02)
                            case 3:
                                return .init(width: width * 0.85, height: height * 0.09)
                            case 4:
                                return .init(width: width * 0.25, height: height * 0.07)
                            case 5:
                                return .init(width: width * 0.51, height: height * 0.04)
                            case 6:
                                return .init(width: width * 0.58, height: height * 0.25)
                            case 7:
                                return .init(width: width * 0.08, height: height * 0.12)
                            default:
                                return .zero
                            }
                        }
                        var color: Color {
                            if i == 7 {
                                return Color(AssetsCatalog.goalColorID)
                            } else {
                                return Color.accentColor
                            }
                        }
                        
                        Circle()
                            .foregroundStyle(color)
                            .frame(width: size)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .offset(offset)
                    }
                }
            }
            .clipped()
        }
    }
}

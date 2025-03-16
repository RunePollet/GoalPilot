//
//  GMStarPowerup.swift
//  GoalPilot
//
//  Created by Rune Pollet on 10/01/2025.
//

import SwiftUI

/// A star powerup view connected to the global model.
struct GMStarPowerup: View {
    @Environment(GlobalViewModel.self) private var globalModel
    
    @State private var showPostTitle = false
    
    var body: some View {
        GeometryReader { geo in
            var streakCounterFrame: CGRect {
                if let anchor = globalModel.targetAnchor {
                    return geo[anchor]
                }
                return .init(x: geo.size.width, y: 0, width: 0, height: 0)
            }
            var destination: UnitPoint {
                let result = UnitPoint(x: streakCounterFrame.midX/geo.size.width, y: streakCounterFrame.midY/geo.size.height)
                return result
            }
            
            ZStack {
                // Background
                if globalModel.showPowerup[0] {
                    Color.black
                        .ignoresSafeArea()
                }
                
                // Powerup
                if globalModel.showPowerup[1] {
                    MoveAlongCurve(
                        progress: globalModel.slideProgress,
                        content: { path in
                            StarPowerupView(handler: globalModel.starPowerupHandler)
                                .scaleEffect(globalModel.slideProgress == 1 ? 0 : 1)
                        },
                        departPosition: .center,
                        destinationPosition: destination,
                        pathProvider: { path, departure, destination, size in
                            path.move(to: departure)
                            path.addCurve(to: destination,
                                          control1: .init(x: 0, y: 0.6 * size.height),
                                          control2: .init(x: 0, y: 0.3 * size.height))
                        }
                    )
                }
                
                // Pretitles
                ZStack {
                    if globalModel.showTitleCarousel {
                        TextCarousel(texts: globalModel.pretitles)
                            .foregroundStyle(.white)
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }
                }
                
                // Posttitle
                if showPostTitle {
                    Text(globalModel.posttitle!)
                        .foregroundStyle(.white)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 40)
                }
            }
        }
        .onChange(of: globalModel.starPowerupHandler.mainStarPop) { oldValue, newValue in
            if globalModel.posttitle != nil && newValue {
                withAnimation {
                    showPostTitle = true
                }
            }
        }
        .onChange(of: globalModel.showPowerup[0]) { oldValue, newValue in
            if globalModel.posttitle != nil && !newValue {
                withAnimation {
                    showPostTitle = false
                }
            }
        }
    }
}

//
//  MAAnimationView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 30/12/2024.
//

import SwiftUI
import SwiftData

/// An animation appropriate for when the user achieved a milestone.
struct MAAnimationView: View {
    var handler: MAAnimationHandler
    
    @State private var indicatorAnchor: Anchor<CGRect>?
    private var starIndicator: Landscape.StarIndicator {
        let index = handler.currentStar == nil ? 0 : handler.landscapeStars.firstIndex(of: handler.currentStar!)
        switch index {
        case 1:
            return .secondHillFirst
        case 2:
            return .secondHillSecond
        case 3:
            return .thirdHill
        default:
            return .firstHill
        }
    }
    
    var body: some View {
        ZStack {
            // Sky
            if handler.sky {
                Group {
                    Color(uiColor: .systemBackground)
                    Landscape.SkyGradient(timeOfDay: TimeOfDayService.current(), stop: 0.5)
                }
                .ignoresSafeArea()
                .zIndex(1)
            }
            
            // Landscape
            if handler.landscape {
                MAAnimatedLandscape()
                    .transition(.move(edge: .bottom))
                    .zIndex(2)
            }
            
            // Star
            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height
                var destination: UnitPoint {
                    if let indicatorAnchor {
                        let frame = geo[indicatorAnchor]
                        return .init(x: frame.midX/width, y: frame.midY/height)
                    }
                    return .bottomLeading
                }
                
                if handler.star {
                    MoveAlongCurve(
                        progress: handler.starProgress,
                        content: { _ in
                            // Star configuration
                            let leftEye = StarFigure.Eye(
                                side: .left,
                                frame: (30/300, 45/300), pupilFrame: (9.14/20.2, 10.73/29.18),
                                pupilOffset: (0, handler.starFace ? 0.25 : 0))
                            let leftEyebrow = StarFigure.Eyebrow(
                                side: .left,
                                frame: (handler.starFace ? 35/300 : 40/300, 20/300),
                                rotation: .degrees(-15),
                                offset: (3/300, handler.starFace ? -50/300 : -40/300),
                                scaleAnchor: .trailing)
                            let rightEye = StarFigure.Eye(
                                side: .right,
                                frame: (30/300, 45/300), pupilFrame: (9.14/20.2, 10.73/29.18),
                                pupilOffset: (0, handler.starFace ? 0.25 : 0))
                            let rightEyebrow = StarFigure.Eyebrow(
                                side: .right,
                                frame: (handler.starFace ? 35/300 : 40/300, 20/300),
                                rotation: .degrees(15),
                                offset: (-3/300, handler.starFace ? -50/300 : -40/300),
                                scaleAnchor: .leading)
                            let mouth = StarFigure.Mouth(frame: (70/300, handler.starFace ? 70/300 : 53.85/300))
                            let config = StarFigure.StarViewConfiguration(
                                character: .milestone,
                                leftEye: leftEye,
                                rightEye: rightEye,
                                leftEyebrow: leftEyebrow,
                                rightEyebrow: rightEyebrow,
                                mouth: mouth)
                            
                            StarFigure.StarView(config: config)
                                .frame(width: pct(200/393, of: .width), height: pct(200/393, of: .width))
                                .scaleEffect(handler.starProgress == 0 ? 1 : 0)
                        },
                        departPosition: UnitPoint(x: 0.5, y: 0.3),
                        destinationPosition: destination,
                        pathProvider: { path, departure, destination, size in
                            path.move(to: departure)
                            path.addCurve(to: destination,
                                          control1: CGPoint(x: size.width*0.5, y: size.height*0.25),
                                          control2: CGPoint(x: size.width, y: size.height*0.5))
                        }
                    )
                    .transition(.scale)
                }
            }
            .zIndex(3)
            
            // Title
            if handler.title {
                Text("Milestone \(handler.currentMilestone?.orderIndex ?? 0) achieved!")
                    .font(.title)
                    .fontWeight(.bold)
                    .transition(.opacity)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, 40)
                    .padding(.horizontal)
                    .zIndex(4)
            }
            
            // Text carousel for when all milestones are achieved
            if handler.textCarousel {
                TextCarousel(texts: ["Uh... wow", "Are you seeing this?", "You've achieved all your milestones!", "So that means..."])
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, pct(1/4, of: .height))
                    .zIndex(5)
            }
        }
        .environment(handler)
        .onPreferenceChange(Landscape.StarIndicatorBounds.self) { values in
            DispatchQueue.main.async {
                if let value = values[starIndicator.id.uuidString] {
                    self.indicatorAnchor = value
                }
            }
        }
    }
}

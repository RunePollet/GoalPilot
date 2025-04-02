//
//  LandscapeView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 24/11/2024.
//

import SwiftUI

extension Landscape {
    /// The main landscape view.
    struct LandscapeView: View {
        var stars: [StarConfiguration]
        var focusedStar: StarConfiguration?
        var glow: Bool
        var goalStarGlow: Bool
        var pathwayStyles: [[PathwayView.Style]]
        
        static let goalStarID = "GOAL_STAR"
        private var currentTimeOfDay: TimeOfDayService.TimeOfDay { TimeOfDayService.current() }
        
        init(stars: [StarConfiguration], focusedStar: StarConfiguration?, glow: Bool = false, goalStarGlow: Bool = false) {
            self.stars = stars
            self.focusedStar = focusedStar
            self.glow = glow
            self.goalStarGlow = goalStarGlow
            self.pathwayStyles = [[.todo], [.todo, .todo], [.todo], [.todo, .todo], [.todo]]
            
            Self.setPathwayStyles(styles: &pathwayStyles, stars: stars, focusedStar: focusedStar)
        }
        
        init(stars: [StarConfiguration], glow: Bool = false, goalStarGlow: Bool = false, pathwayStyles: [[PathwayView.Style]]) {
            self.stars = stars
            self.glow = glow
            self.goalStarGlow = goalStarGlow
            self.pathwayStyles = pathwayStyles
        }
        
        var body: some View {
            GeometryReader { geo in
                let size = CGSize(width: geo.size.width, height: geo.size.width * 292/393)
                
                ZStack(alignment: .topLeading) {
                    wheather
                    
                    landscape(size: size)
                    
                    // Goal star
                    StarFigure.StarShape()
                        .foregroundStyle(Color(AssetsCatalog.goalColorID))
                        .frame(width: size.width * 23.0/393.0, height: size.width * 23.0/393.0)
                        .shadow(color: goalStarGlow ? Color.black.opacity(0.4) : Color.clear, radius: 5)
                        .anchorPreference(key: StarIndicatorBounds.self, value: .bounds) { anchor in
                            [Self.goalStarID: anchor]
                        }
                        .padding(4)
                        .background {
                            if goalStarGlow {
                                Circle()
                                    .foregroundStyle(.purple)
                                    .blur(radius: 15)
                            }
                        }
                        .offset(x: size.width * 40.063/393.0, y: size.height * 23.0/292.0)
                }
                .frame(width: size.width, height: size.height)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .preferredColorScheme(currentTimeOfDay.preferredColorScheme)
            }
        }
        
        @ViewBuilder
        private var wheather: some View {
            switch currentTimeOfDay {
            case .sunrise:
                Sunrise()
            case .day:
                Day()
            case .sunset:
                Sunset()
            case .night:
                Night()
            }
        }
        
        private func landscape(size: CGSize) -> some View {
            ZStack(alignment: .bottom) {
                // Sea
                Group {
                    Color(AssetsCatalog.seaColorID)
                    if currentTimeOfDay == .sunset || currentTimeOfDay == .sunrise {
                        LinearGradient(
                            stops: [
                                .init(color: .clear, location: 0),
                                .init(color: .orange.opacity(currentTimeOfDay == .sunset ? 0.4 : 0.3), location: 0.51),
                                .init(color: .clear, location: 1)
                            ],
                            startPoint: .init(x: 0.1, y: 1),
                            endPoint: .init(x: 0.9, y: 0)
                        )
                        .shadow(color: .white.opacity(0.7), radius: 5)
                    }
                }
                .frame(height: size.width * 124.0/393.0)
                
                // Fourth hill
                HillView(.fourth)
                
                // Third hill
                HillView(.third)
                if stars.count >= 5 {
                    let pathwayStyle = pathwayStyles[4]
                    PathwayView(.thirdHillSecondLeg, style: pathwayStyle[0], glow: glow)
                }
                if stars.count >= 4 {
                    let star = stars[3]
                    let pathwayStyle = pathwayStyles[3]
                    PathwayView(.thirdHillFirstLeg, style: pathwayStyle[1], glow: glow)
                    StarIndicatorView(.thirdHill, number: star.number, reached: star.reached, glow: glow)
                }
                
                // Second hill
                HillView(.second)
                if stars.count >= 4 {
                    let pathwayStyle = pathwayStyles[3]
                    PathwayView(.secondHillThirdLeg, style: pathwayStyle[0], glow: glow)
                }
                if stars.count >= 3 {
                    let star = stars[2]
                    let pathwayStyle = pathwayStyles[2]
                    PathwayView(.secondHillSecondLeg, style: pathwayStyle[0], glow: glow)
                    StarIndicatorView(.secondHillSecond, number: star.number, reached: star.reached, glow: glow)
                }
                if stars.count >= 2 {
                    let star = stars[1]
                    let pathwayStyle = pathwayStyles[1]
                    PathwayView(.secondHillFirstLeg, style: pathwayStyle[1], glow: glow)
                    StarIndicatorView(.secondHillFirst, number: star.number, reached: star.reached, glow: glow)
                }
                
                // First hill
                HillView(.first)
                if stars.count >= 2 {
                    let pathwayStyle = pathwayStyles[1]
                    PathwayView(.firstHillSecondLeg, style: pathwayStyle[0], glow: glow)
                }
                if stars.count >= 1 {
                    let star = stars[0]
                    let pathwayStyle = pathwayStyles[0]
                    PathwayView(.firstHillFirstLeg, style: pathwayStyle[0], glow: glow)
                    StarIndicatorView(.firstHill, number: star.number, reached: star.reached, glow: glow)
                }
            }
        }
        
        /// Returns an array of integers representing the star numbers that should be shown on the landscape.
        static func getLandscapeStars(nextStarToReach: Landscape.LandscapeView.StarConfiguration?, totalStars: [Landscape.LandscapeView.StarConfiguration]) -> [Landscape.LandscapeView.StarConfiguration] {
            let groups: Int = totalStars.count / 4
            let remainder: Int = Int(CGFloat(totalStars.count).truncatingRemainder(dividingBy: 4))
            
            guard groups >= 1 else {
                if remainder > 0 {
                    return Array(totalStars[0...remainder-1])
                } else {
                    return []
                }
            }
            
            for group in 1...groups {
                let lowerBound = (group-1) * 4 + 1
                let upperBound = group * 4
                var values = totalStars[lowerBound-1...upperBound-1]
                if nextStarToReach == nil || (nextStarToReach != nil && values.contains(nextStarToReach!)) {
                    if upperBound < totalStars.count {
                        let nextValue = totalStars[upperBound]
                        values.append(nextValue)
                    }
                    return Array(values)
                }
            }
            
            let lastUpperBound = groups * 4
            return Array(totalStars[lastUpperBound...lastUpperBound+remainder-1])
        }
        
        /// Sets the styles to their appropriate values.
        static func setPathwayStyles(styles: inout [[PathwayView.Style]], stars: [StarConfiguration], focusedStar: StarConfiguration?) {
            for (i, star) in stars.enumerated() {
                if i < styles.count {
                    if star != focusedStar {
                        setPathwayStyle(to: star.reached ? .reached : .todo, in: &styles[i])
                    } else {
                        setPathwayStyle(to: star.reached ? .reached : .focused, in: &styles[i])
                    }
                }
            }
        }
        
        static func setPathwayStyle(to style: PathwayView.Style, in array: inout [PathwayView.Style]) {
            for i in 0..<array.count {
                array[i] = style
            }
        }
    }
}

// Star Configurations
extension Landscape.LandscapeView {
    struct StarConfiguration: Equatable {
        var number: Int
        var reached: Bool
    }
}

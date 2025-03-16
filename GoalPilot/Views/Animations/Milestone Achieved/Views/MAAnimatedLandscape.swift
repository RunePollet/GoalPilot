//
//  MAAnimatedLandscape.swift
//  GoalPilot
//
//  Created by Rune Pollet on 31/12/2024.
//

import SwiftUI

/// An animated landscape that reacts to an environment milestone achieved animation handler.
struct MAAnimatedLandscape: View {
    @Environment(MAAnimationHandler.self) private var handler
    
    @State private var pathwayStyles: [[Landscape.PathwayView.Style]] = [[.todo], [.todo, .todo], [.todo], [.todo, .todo], [.todo]]
    
    var body: some View {
        VStack(spacing: 0) {
            Landscape.LandscapeView(
                stars: handler.landscapeStars,
                glow: handler.glow,
                pathwayStyles: pathwayStyles
            )
            Rectangle()
                .foregroundStyle(Color(AssetsCatalog.firstHillColorID))
                .frame(height: 40)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .onAppear {
            Landscape.LandscapeView.setPathwayStyles(styles: &pathwayStyles, stars: handler.landscapeStars, focusedStar: handler.focusedStar)
        }
        .onChange(of: handler.reachedPathwayToStar) { oldValue, newValue in
            if let newValue {
                closePathwayTo(star: newValue)
            }
        }
        .onChange(of: handler.upcomingPathwayAfterStar) { oldValue, newValue in
            if let newValue {
                glowPathwayAfter(star: newValue)
            }
        }
    }
    
    func closePathwayTo(star: Landscape.LandscapeView.StarConfiguration) {
        let index = handler.landscapeStars.firstIndex(of: star) ?? handler.landscapeStars.count
        
        let totalDuration: Double = 2
        let styles = pathwayStyles[index]
        let duration = totalDuration/Double(styles.count)
        for legIndex in 0..<styles.count {
            withAnimation(.smooth(duration: duration).delay(Double(legIndex)*duration)) {
                pathwayStyles[index][legIndex] = .reached
            }
        }
    }
    
    func glowPathwayAfter(star: Landscape.LandscapeView.StarConfiguration) {
        let index = handler.landscapeStars.firstIndex(of: star) ?? handler.landscapeStars.count
        let newIndex = index + 1
        
        if newIndex < pathwayStyles.count {
            withAnimation(.smooth(duration: 1)) {
                Landscape.LandscapeView.setPathwayStyle(to: .focused, in: &pathwayStyles[newIndex])
            }
        }
    }
}

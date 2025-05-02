//
//  MAAnimationHandler.swift
//  GoalPilot
//
//  Created by Rune Pollet on 30/12/2024.
//

import SwiftUI

/// Handles a milestone achieved animation.
@MainActor
@Observable
class MAAnimationHandler {
    
    // Animations
    var title = false
    var textCarousel = false
    var sky = false
    var star = false
    var starFace = false
    var starProgress: CGFloat = 0
    var landscape = false
    var glow = false
    var reachedPathwayToStar: Landscape.LandscapeView.StarConfiguration?
    var upcomingPathwayAfterStar: Landscape.LandscapeView.StarConfiguration?
    
    // Feedback
    var impactFeedback = false
    var successFeedback = false
    var errorFeedback = false
    
    // Accessibility
    var isAnimating = false
    var totalDuration: CGFloat = 0
    
    var slideTarget: Anchor<CGRect>?
    
    var currentMilestone: Milestone?
    var currentStar: Landscape.LandscapeView.StarConfiguration? {
        landscapeStars.first(where: { $0.number == currentMilestone?.orderIndex })
    }
    
    var milestones: [Milestone] = []
    var lastAchievedMilestone: Milestone? { milestones.last { $0.achieved } }
    var landscapeStars: [Landscape.LandscapeView.StarConfiguration] = []
    var focusedStar: Landscape.LandscapeView.StarConfiguration?
    
    init() {}
    
    func runAnimation(for milestone: Milestone, milestones: [Milestone], focusedMilestone: Milestone?, globalModel: GlobalViewModel, completion: (() -> Void)? = nil, allMilestonesAchievedCompletion: (() -> Void)? = nil) {
        let allMilestonesAchieved = milestones.filter({ $0.achieved }).count == milestones.count-1
        
        // Prepare for the animation
        self.milestones = milestones
        focusedStar = focusedMilestone?.asStarConfiguration
        landscapeStars = Landscape.LandscapeView.getLandscapeStars(nextStarToReach: milestones.first(where: { !$0.achieved })?.asStarConfiguration, totalStars: milestones.map(\.asStarConfiguration))
        currentMilestone = milestone
        isAnimating = true
        
        // Show the star and title
        animate(duration: 0.5, delay: 0, animation: .bouncy) {
            self.title = true
            self.star = true
        }
        animate(duration: 0.5, delay: 0.5, animation: .easeOut(duration: 0.5)) {
            self.starFace = true
        }
        
        // Show the sky and the landscape
        animate(duration: 1.5, delay: -1.5, animation: .smooth(duration: 1.5)) {
            self.sky = true
            self.landscape = true
        }
        
        // Glow the path and change the star's face
        animate(duration: 1, delay: 0, animation: .easeIn(duration: 1)) {
            self.glow = true
        }
        
        // Show the path
        sequence(duration: 1, delay: -1) {
            self.reachedPathwayToStar = self.currentStar
        }
        
        // Move the star to the indicator and glow it
        animate(duration: 0.5, delay: 0, animation: .easeOut(duration: 0.5)) {
            self.starFace = false
        }
        animate(duration: 1, delay: 0.5, animation: .easeInOut(duration: 1)) {
            self.starProgress = 1
        }
        animate(duration: 0.3, delay: 0, animation: .easeOut(duration: 0.3)) {
            if let currentStar = self.currentStar, let index = self.landscapeStars.firstIndex(of: currentStar) {
                self.landscapeStars[index].reached = true
                self.successFeedback.toggle()
            }
        }
        
        if !allMilestonesAchieved {
            // Glow the next path
            sequence(duration: 1, delay: 0.5) {
                self.upcomingPathwayAfterStar = self.currentStar
            }
        }
        
        if allMilestonesAchieved {
            // Hide the title and show the text carousel
            animate(duration: 0.3, delay: 0, animation: .smooth(duration: 0.3)) {
                self.title = false
            }
            sequence(duration: 8, delay: 0) {
                self.textCarousel = true
                self.errorFeedback.toggle()
            }
        }
        
        if !allMilestonesAchieved {
            // Stop the animation
            animate(duration: 1.5, delay: 0.5, animation: .easeInOut(duration: 1.5)) {
                self.landscape = false
                self.sky = false
                if allMilestonesAchieved {
                    self.textCarousel = false
                } else {
                    self.title = false
                }
            }
            sequence(duration: 0, delay: 0) {
                self.reset()
                completion?()
            }
        } else {
            // Present the star powerup
            sequence(duration: 0, delay: 2) {
                globalModel.presentStarPowerup(fadeIn: true, color: Color(AssetsCatalog.goalColorID), secondColor: nil, posttitle: "You've achieved your ultimate life goal!", targetAnchor: self.slideTarget, presentCompletion: {
                    self.reset()
                    completion?()
                }, hideCompletion: {
                    allMilestonesAchievedCompletion?()
                })
            }
        }
    }
    
    /// Animates and sequences the action in the animation.
    func animate(duration: CGFloat, delay: CGFloat, animation: Animation, action: @escaping () -> Void) {
        sequence(duration: duration, delay: delay) {
            withAnimation(animation) {
                action()
            }
        }
    }
    
    /// Sequences the action in the animation.
    func sequence(duration: CGFloat, delay: CGFloat, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration + delay) {
            completion()
        }
        totalDuration += delay
        totalDuration += duration
    }
    
    func reset() {
        title = false
        textCarousel = false
        sky = false
        star = false
        starFace = false
        starProgress = 0
        landscape = false
        glow = false
        reachedPathwayToStar = nil
        upcomingPathwayAfterStar = nil
        isAnimating = false
        totalDuration = 0
        currentMilestone = nil
    }
}

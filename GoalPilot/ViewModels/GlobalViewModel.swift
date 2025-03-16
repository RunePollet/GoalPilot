//
//  DataViewModel.swift
//  GoalPilot
//
//  Created by Rune Pollet on 28/03/2024.
//

import SwiftUI
import SwiftData

/// The view model for general access all over the app.
@Observable
class GlobalViewModel {
    
    // View coordination
    var resetUITrigger = false
    
    // Accessibility
    @MainActor
    private var notificationService = NotificationService.shared
    private(set) var selectedAppIcon: AppIcon
    
    // Planning creation sheet
    var showFirstPlanningCreationSheet = false
    var includeAlert = false
    
    // Star Powerup animation
    @MainActor
    var starPowerupHandler = StarPowerupHandler()
    var showTitleCarousel = false
    var showPowerup = [false, false]
    var pretitles: [String] = []
    var posttitle: String? = nil
    var slideProgress: CGFloat = 0.0
    var targetAnchor: Anchor<CGRect>?
    var hideCompletion: () -> Void = {}
    
    init() {
        // Set the selected app icon
        if let iconName = UserDefaults.standard.string(forKey: Keys.appIconKey), let appIcon = AppIcon(rawValue: iconName) {
            selectedAppIcon = appIcon
        } else {
            selectedAppIcon = .blue
        }
    }
    
    /// Prepares the app for reuse.
    func cleanUp(plannerModel: PlannerViewModel, streakModel: StreakViewModel) {
        resetUITrigger.toggle()
        streakModel.resetStreak()
        plannerModel.resetCurrentPlanning()
    }
}

// Alternating app icon support
extension GlobalViewModel {
    func setAlternateAppIcon(to appIcon: AppIcon) {
        guard selectedAppIcon != appIcon else {
            return
        }
        
        UIApplication.shared.setAlternateIconName(appIcon.iconName)
        UserDefaults.standard.set(appIcon.iconName, forKey: Keys.appIconKey)
        selectedAppIcon = appIcon
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}

// Create planning sheet support
extension GlobalViewModel {
    func showFirstPlanningCreationSheet(includeAlert: Bool = false) {
        self.showFirstPlanningCreationSheet = true
        self.includeAlert = includeAlert
    }
}

// Star Powerup animation support
extension GlobalViewModel {
    /// Presents the star powerup animation to increase the streak.
    @MainActor
    func presentStarPowerup(fadeIn: Bool, color: Color = Color.accentColor, secondColor: Color? = Color(AssetsCatalog.goalColorID), pretitles: [String] = [], posttitle: String? = nil, targetAnchor: Anchor<CGRect>?, presentCompletion: @escaping () -> Void = {}, hideCompletion: @escaping () -> Void = {}) {
        // Reset the handler
        starPowerupHandler.reset()
        
        // Set values
        starPowerupHandler.color = color
        starPowerupHandler.secondColor = secondColor
        starPowerupHandler.completion = endAnimation
        self.pretitles = pretitles
        self.posttitle = posttitle
        self.targetAnchor = targetAnchor
        self.hideCompletion = hideCompletion
        
        let titleDuration = CGFloat(pretitles.count)*2.7
        let fadeInDuration = 1.5
        if fadeIn {
            let carouselFadeInDuration = 0.7
            
            // Show the background
            withAnimation(.easeIn(duration: fadeInDuration)) {
                showPowerup[0] = true
            }
            
            // Show the titles
            DispatchQueue.main.asyncAfter(deadline: .now() + fadeInDuration) {
                withAnimation(.smooth(duration: carouselFadeInDuration)) {
                    self.showTitleCarousel = true
                }
            }
            
            // Show the star powerup
            DispatchQueue.main.asyncAfter(deadline: .now() + fadeInDuration + carouselFadeInDuration + titleDuration) {
                withAnimation {
                    self.showPowerup[1] = true
                }
            }
        } else {
            showPowerup = [true, false]
            showTitleCarousel = true
            DispatchQueue.main.asyncAfter(deadline: .now() + titleDuration + 0.3) {
                withAnimation {
                    self.showPowerup[1] = true
                }
            }
        }
        
        // Reset the UI after the streak updater appeared
        DispatchQueue.main.asyncAfter(deadline: .now() + (fadeIn ? fadeInDuration : 0)) {
            self.resetUITrigger.toggle()
            presentCompletion()
        }
    }
    
    /// Ends the star powerup animation and increases the streak.
    @MainActor
    func endAnimation() {
        // Hide the background
        withAnimation(.easeIn(duration: 0.5)) {
            showPowerup[0] = false
        }
        
        // Move the star to the streak counter
        withAnimation(.easeInOut(duration: 1)) {
            slideProgress = 1
        } completion: {
            // Hide the star powerup and reset the MoveAlongCurve progress
            self.showPowerup[1] = false
            self.slideProgress = 0

            // Run hide completion
            self.hideCompletion()
        }
    }
}


// Keys
private extension GlobalViewModel {
    class Keys {
        static let appIconKey = "APP_ICON"
    }
}

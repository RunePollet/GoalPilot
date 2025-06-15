//
//  StarPowerupHandler.swift
//  GoalPilot
//
//  Created by Rune Pollet on 19/01/2024.
//

import SwiftUI

/// Handles a star powerup animation.
@MainActor
@Observable
class StarPowerupHandler {
    
    var completion: () -> Void
    
    // Style
    var color: Color
    var secondColor: Color?
    var mainStarCharacter: StarFigure.StarViewConfiguration.Character
    
    // PressingIndicator
    var showPressingIndicator = true
    var isPressing: Bool = false
    
    // Main Star
    private let mainStarScaleOrigin: CGFloat = 0
    private let mainStarBlurOrigin: CGFloat = 5
    private let mainStarScaleTarget: CGFloat = 1
    private let mainStarBlurTarget: CGFloat = 50
    
    var mainStarScale: CGFloat
    var mainStarShadowBlur: CGFloat = 5
    private var mainStarRewindTimer: Timer?
    private var mainStarStopTimer: Timer?
    
    private var forceStarSpawn = false
    
    var mainStarPop = false
    
    // Particles
    var showStars = false
    
    // Powerup Completion
    private var scheduleDate: Date?
    private let timeInterval = 5.0
    
    // Timers
    private var completionTimer: Timer?
    private var rewindTimer: Timer = Timer()
    private var stopMainStarAnimationTimer: Timer = Timer()
    
    /// Indicates if the user has currently completed the powerup animation.
    private var mainStarReachedTarget: Bool {
        if let completionTimer {
            return completionTimer.fireDate <= Date.now
        }
        return false
    }
    
    init(color: Color = .accentColor, secondColor: Color? = nil, mainStarCharacter: StarFigure.StarViewConfiguration.Character = .goal, completion: @escaping () -> Void = {}) {
        self.completion = completion
        self.color = color
        self.secondColor = secondColor
        self.mainStarCharacter = mainStarCharacter
        self.mainStarScale = mainStarScaleOrigin
    }
    
    /// Starts the powerup animation.
    func startPowerupAnimation() {
        isPressing = true
        if !mainStarReachedTarget {
            // Invalidate counteracting timers and show stars
            rewindTimer.invalidate()
            stopMainStarAnimationTimer.invalidate()
            
            forceStarSpawn = true
            DispatchQueue.main.async { [self] in
                withAnimation {
                    showStars = true
                    showPressingIndicator = false
                }
            }
            
            // Start the main-star animation
            completionTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(completePowerupAnimation), userInfo: nil, repeats: false)
            scheduleDate = .now
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                if isPressing {
                    startMainStarAnimation(duration: timeInterval-1)
                }
            }
        }
    }
    
    /// Stops the powerup animation and cancels any future events.
    func stopPowerupAnimation() {
        isPressing = false
        if !mainStarReachedTarget {
            let pressDuration = scheduleDate?.distance(to: .now)
            
            // Stop spawning stars and cancel the time
            var deadline: DispatchTime {
                guard let pressDuration = pressDuration else { return .now() }
                return .now() + (pressDuration > 0.3 ? 0.1 : 0.0)
            }
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                self.showStars = false
            }
            self.completionTimer?.invalidate()
            self.completionTimer = nil
            
            // Rewind the main star after all stars have arrived
            var rewindDuration: Double {
                guard let pressDuration = pressDuration else { return scheduleDate?.distance(to: .now) ?? 2 }
                return pressDuration > 0.3 ? scheduleDate?.distance(to: .now) ?? 2 : 1
            }
            var interval: Double {
                guard let pressDuration = pressDuration else { return 0 }
                return pressDuration > 0.3 ? 0 : 1.5
            }
            rewindTimer.invalidate()
            rewindTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { timer in
                DispatchQueue.main.async {
                    self.rewindMainStarAnimation(duration: rewindDuration)
                    
                    // Stop the animation of the main star
                    self.stopMainStarAnimationTimer.invalidate()
                    self.stopMainStarAnimationTimer = Timer.scheduledTimer(withTimeInterval: rewindDuration, repeats: false) { timer in
                        DispatchQueue.main.async {
                            self.stopMainStarAnimation()
                        }
                    }
                }
            }
        }
    }
    
    /// Completes the powerup animation and continues to the next phase.
    @objc func completePowerupAnimation() {
        // Invalidate all timers
        rewindTimer.invalidate()
        stopMainStarAnimationTimer.invalidate()
        
        // Trigger the appear animation and stop spawning the star particles
        DispatchQueue.main.async { [self] in
            showStars = false
            mainStarPop = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            self.completion()
        }
    }
    
    /// Resets the handler for a new powerup animation.
    func reset() {
        showPressingIndicator = true
        isPressing = false
        mainStarScale = mainStarScaleOrigin
        mainStarShadowBlur = mainStarBlurOrigin
        mainStarRewindTimer = nil
        mainStarStopTimer = nil
        forceStarSpawn = false
        mainStarPop = false
        scheduleDate = nil
        
        completionTimer?.invalidate()
        rewindTimer.invalidate()
        mainStarRewindTimer?.invalidate()
        mainStarStopTimer?.invalidate()
        completionTimer = nil
        mainStarRewindTimer = nil
        mainStarStopTimer = nil
    }
    
    /// Returns the color for this star taking the date into account.
    func getColor(date: Date) -> Color {
        if let endDate = completionTimer?.fireDate {
            if let secondColor {
                let distance = date.distance(to: endDate)
                let progress = 1 - (distance/timeInterval)
                
                let first = RandomValue(value: color, occurence: (1-progress) * 100)
                let second = RandomValue(value: secondColor, occurence: progress * 100)
                
                return RandomValue<Color>.randomize(values: [first, second])
            } else {
                return color
            }
        }
        return color
    }
    
    /// Returns a bool whether  a star particle should spawn.
    func spawnStar(_ date: Date) -> Bool {
        guard let endDate = completionTimer?.fireDate, showStars else { return false }
        
        guard !forceStarSpawn else {
            forceStarSpawn = false
            return true
        }
        
        // Randomize the color based on the progress
        let apexDate = endDate.addingTimeInterval(-(timeInterval/2))
        let distance = date.distance(to: apexDate)
        let progress = 1 - (distance/timeInterval)
        
        let falseOccurence = RandomValue(value: false, occurence: progress >= 1 ? 0 : (1-progress) * 100)
        let trueOccurence = RandomValue(value: true, occurence: progress >= 1 ? 100 : progress * 100)
        
        return RandomValue<Bool>.randomize(values: [falseOccurence, trueOccurence])
    }
    
    /// Shows and scales the mainStarScale property and adds haptic feedback at the end.
    private func startMainStarAnimation(duration: Double) {
        if !mainStarReachedTarget {
            DispatchQueue.main.async { [self] in
                withAnimation(.easeIn(duration: duration)) {
                    mainStarScale = mainStarScaleTarget
                    mainStarShadowBlur = mainStarBlurTarget
                }
            }
        }
    }
    
    /// Rewinds the scale of the main star.
    private func rewindMainStarAnimation(duration: Double) {
        DispatchQueue.main.async { [self] in
            withAnimation(.easeInOut(duration: duration)) {
                mainStarScale = mainStarScaleOrigin
                mainStarShadowBlur = mainStarBlurOrigin
            }
        }
    }
    
    /// Stops the main star animation.
    private func stopMainStarAnimation() {
        DispatchQueue.main.async { [self] in
            withAnimation {
                showPressingIndicator = true
            }
        }
    }
}

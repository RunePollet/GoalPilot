//
//  StreakViewModel.swift
//  GoalPilot
//
//  Created by Rune Pollet on 25/12/2024.
//

import SwiftUI
import SwiftData

/// The view model that manages the weekly streak.
@Observable
class StreakViewModel: Persistent, Codable {
    
    // Streak
    var weeklyStreak = 0
    var isStreakFreezed = false
    var completedActivities: [UUID] = []
    
    private var incrementedStreak: Bool = false
    private var lastRefresh: Date?
    
    // Animation
    var animationTargetAnchor: Anchor<CGRect>?
    var animateStreakCounterTrigger = false
    private let titles: [String] = [
        "Great Progress!",
        "Today, you've already earned a star!",
        "Complete your weekly activities to increase your streak"
    ]
    
    // Accessibility
    @MainActor
    private var notificationService = NotificationService.shared
    private var globalModel: GlobalViewModel
    
    init(globalModel: GlobalViewModel) {
        self.globalModel = globalModel
        restore()
    }
    
    func save() {
        saveToDisk()
    }
    
    func restore() {
        restoreFromDisk()
    }
    
    private func saveToDisk() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("StreakViewModel.json")
        do {
            let data = try JSONEncoder().encode(self)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save data to disk: \(error)")
        }
    }
    
    private func restoreFromDisk() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("StreakViewModel.json")
        do {
            let data = try Data(contentsOf: fileURL)
            let decodedModel = try JSONDecoder().decode(StreakViewModel.self, from: data)
            
            weeklyStreak = decodedModel.weeklyStreak
            isStreakFreezed = decodedModel.isStreakFreezed
            completedActivities = decodedModel.completedActivities
            incrementedStreak = decodedModel.incrementedStreak
            lastRefresh = decodedModel.lastRefresh
        } catch {
            print("Failed to restore data from disk: \(error)")
        }
    }
    
    // Codable
    enum CodingKeys: String, CodingKey {
        case weeklyStreak
        case isStreakFreezed
        case completedActivities
        case incrementedStreak
        case lastRefresh
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        weeklyStreak = try container.decode(Int.self, forKey: .weeklyStreak)
        isStreakFreezed = try container.decode(Bool.self, forKey: .isStreakFreezed)
        completedActivities = try container.decode([UUID].self, forKey: .completedActivities)
        incrementedStreak = try container.decode(Bool.self, forKey: .incrementedStreak)
        lastRefresh = try container.decode(Date?.self, forKey: .lastRefresh)
        globalModel = .init()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(weeklyStreak, forKey: .weeklyStreak)
        try container.encode(isStreakFreezed, forKey: .isStreakFreezed)
        try container.encode(completedActivities, forKey: .completedActivities)
        try container.encode(incrementedStreak, forKey: .incrementedStreak)
        try container.encode(lastRefresh, forKey: .lastRefresh)
    }
}

// Weekly streak support
extension StreakViewModel {
    func resetStreak() {
        if !isStreakFreezed {
            weeklyStreak = 0
            incrementedStreak = false
        }
    }
    
    func resetWeek() {
        completedActivities = []
        incrementedStreak = false
    }
    
    /// Enlists an activity as completed and schedules or removes the streak update notification, or presents the streak updater if appropriate.
    @MainActor
    func enlistAsCompleted(activity: Activity, currentPlanning: Planning) {
        completedActivities.append(activity.id)
        checkStreakIncreaser(currentPlanning: currentPlanning)
    }
    
    /// Keeps the streak view model up to date.
    @MainActor
    func refresh(currentPlanning: Planning) {
        guard let lastRefresh else {
            self.lastRefresh = .now
            return
        }
        
        // Check the streak increaser
        checkStreakIncreaser(currentPlanning: currentPlanning)
        
        // Reset the completed activities and incremented streak properties if a new week has started
        if Date.newWeek(since: lastRefresh) {
            // Reset the weekly streak if not all activities were achieved
            if currentPlanning.activities.count > completedActivities.count {
                resetStreak()
            }
            completedActivities = []
            incrementedStreak = false
        }
        
        // Update last refresh date
        self.lastRefresh = .now
    }
    
    /// Schedules or removes the streak increase notification, or presents the streak increaser if appropriate.
    @MainActor
    func checkStreakIncreaser(currentPlanning: Planning) {
        guard let lastRefresh else {
            self.lastRefresh = .now
            return
        }
        
        // Check if all activities are completed
        if currentPlanning.activities.count == completedActivities.count && completedActivities.count != 0 {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: .now)
            let weekday = calendar.component(.weekday, from: .now)
            let weekAndYear = calendar.dateComponents([.weekOfYear, .year], from: .now)
            let lastRefreshWeekAndYear = calendar.dateComponents([.weekOfYear, .year], from: lastRefresh)
            
            if hour >= 19 && weekday == 1 && !incrementedStreak || lastRefreshWeekAndYear != weekAndYear && !incrementedStreak {
                // Present the updater
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.presentStarPowerup(fadeIn: true, isFirst: false)
                }
            } else if !incrementedStreak {
                // Schedule a notification
                addStreakIncrementNotification()
            }
        } else {
            NotificationService.shared.removeNotifications(with: [Keys.weeklyStreak])
        }
    }
    
    /// Presents the star powerup animation to increment the streak.
    @MainActor
    func presentStarPowerup(fadeIn: Bool, isFirst: Bool, isIncrementationFromLastWeek: Bool = false) {
        globalModel.presentStarPowerup(fadeIn: fadeIn, pretitles: isFirst ? titles : [], targetAnchor: animationTargetAnchor, hideCompletion: {
            // Increment the streak
            self.animateStreakCounterTrigger.toggle()
            withAnimation(.smooth) {
                if isFirst {
                    self.weeklyStreak += 1
                } else {
                    self.weeklyStreak += 1
                    self.incrementedStreak = !isIncrementationFromLastWeek
                }
            }
        })
    }
    
    /// Adds a notification at the end of the week to invite the user to increase the weekly streak.
    @MainActor
    private func addStreakIncrementNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Update your streak!"
        content.body = "\(TextService.shared.weeklyFeedbackExclamations.randomElement() ?? "Excellent job this week!") We need your energy to update your weekly streak!"
        
        let triggerDate = Calendar.current.nextDate(after: .now, matching: .init(hour: 19, weekday: 1), matchingPolicy: .nextTime) ?? .now.addingTimeInterval(3600 * 24 * 7)
        
        let components = Calendar.current.dateComponents(in: .current, from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: Keys.weeklyStreak, content: content, trigger: trigger)
        self.notificationService.add(request: request)
    }
}


// Keys
extension StreakViewModel {
    class Keys {
        static let weeklyStreak = "WEEKLY_STREAK"
    }
}

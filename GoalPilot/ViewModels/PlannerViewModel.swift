//
//  PlannerViewModel.swift
//  GoalPilot
//
//  Created by Rune Pollet on 31/10/2024.
//

import SwiftUI
import SwiftData

/// The view model that manages the planner.
@Observable
class PlannerViewModel: Persistent {
    
    // View coordination
    private(set) var currentPlanning: Planning?
    var currentDate: Date = .now
    private var currentPlanningID: PersistentIdentifier?
    
    private(set) var displayedDates: [Date] = []
    private(set) var displayedMonth: DateComponents = Calendar.current.dateComponents([.year, .month], from: Date.now)
    var firstDateOfDisplayedMonth: Date {
        calendar.date(from: displayedMonth)!
    }
    var lastDateOfDisplayedMonth: Date {
        let lastDate = calendar.date(byAdding: .month, value: 1, to: firstDateOfDisplayedMonth)!
        return calendar.date(byAdding: .day, value: -1, to: lastDate)!
    }
    
    // Accessibility
    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.timeZone = .gmt
        return calendar
    }
    
    init(_ modelContext: ModelContext) {
        fetchDates()
        restoreCurrentPlanningID()
        updateCurrentPlanning(modelContext)
    }
    
    func save() {
        saveCurrentPlanningID()
    }
    
    func restore() {
        restoreCurrentPlanningID()
    }
}

// Dates
extension PlannerViewModel {
    func loadDatesForNextMonth(inDirection direction: Calendar.SearchDirection, animation: Animation? = nil) {
        // Update the displayedMonth property
        let dateInNextMonth = calendar.date(byAdding: .month, value: direction == .forward ? 1 : -1, to: firstDateOfDisplayedMonth)!
        withAnimation(animation) {
            displayedMonth = calendar.dateComponents([.year, .month], from: dateInNextMonth)
        }
        
        // Fetch the dates of this month
        fetchDates()
        
        // Set the current date
        updateCurrentDate()
    }
    
    /// Updates the current date to fit the displayed month.
    func updateCurrentDate() {
        let nowComponents = calendar.dateComponents([.year, .month], from: .now)
        if nowComponents == displayedMonth {
            currentDate = .now
        } else if firstDateOfDisplayedMonth > .now {
            currentDate = firstDateOfDisplayedMonth
        } else {
            currentDate = lastDateOfDisplayedMonth
        }
    }
    
    /// Fetches all dates for the displayedMonth and updates the displayedDates.
    private func fetchDates() {
        var components = displayedMonth
        var dates: [Date] = []
        
        // Get the range of days in this month
        if let range = calendar.range(of: .day, in: .month, for: firstDateOfDisplayedMonth) {
            for day in range {
                components.day = day
                if let date = calendar.date(from: components) {
                    dates.append(date)
                }
            }
        }
        
        displayedDates = dates
    }
}

// Accessors for currentPlanning
extension PlannerViewModel {
    func updateCurrentPlanning(_ modelContext: ModelContext) {
        if let id = currentPlanningID,
           let planning: Planning = modelContext.registeredModel(for: id),
           let activePlanning = planning.activeValue {
            currentPlanning = activePlanning
            return
        }
        
        currentPlanning = Planning.latest(from: modelContext)
    }
    
    @MainActor
    func setCurrentPlanning(to newPlanning: Planning?, using modelContext: ModelContext) {
        guard newPlanning?.persistentModelID != currentPlanningID else { return }
        let notificationService = NotificationService.shared
        
        if let currentPlanningID {
            let oldPlanning: Planning? = modelContext.registeredModel(for: currentPlanningID)
            notificationService.removeAllNotifications(for: oldPlanning)
        }
        
        currentPlanningID = newPlanning?.persistentModelID
        updateCurrentPlanning(modelContext)
        if let newPlanning {
            notificationService.updateAllNotifications(for: newPlanning)
        }
    }
    
    func resetCurrentPlanning() {
        currentPlanningID = nil
        currentPlanning = nil
    }
    
    private func saveCurrentPlanningID() {
        if let encodedData = try? JSONEncoder().encode(currentPlanningID) {
            UserDefaults.standard.set(encodedData, forKey: Keys.currentPlanningID)
        }
    }
    
    private func restoreCurrentPlanningID() {
        if let savedData = UserDefaults.standard.data(forKey: Keys.currentPlanningID),
           let savedID = try? JSONDecoder().decode(PersistentIdentifier.self, from: savedData) {
            currentPlanningID = savedID
        }
    }
}

// Standby mode
extension PlannerViewModel {
    @MainActor
    func enableStandbyMode(_ modelContext: ModelContext, streakModel: StreakViewModel, disableCompletion: (() -> Void)? = nil) {
        // Freeze the weekly streak
        streakModel.isStreakFreezed = true
        
        // Remove all notifications
        let notificationService = NotificationService.shared
        notificationService.removeAllNotifications()
        
        // Add notification in 3 weeks
        let content = UNMutableNotificationContent()
        content.title = "Standby mode"
        content.body = "How are you doing?"
        
        let triggerDate = Calendar.current.date(byAdding: .weekOfYear, value: 3, to: .now)!
        let components = Calendar.current.dateComponents(in: .current, from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: Keys.standbyNotification, content: content, trigger: trigger)
        notificationService.add(request: request) {
            WindowService.window()?.presentAlert(.disableStandbyMode({
                Task {
                    await self.disableStandbyMode(modelContext, streakModel: streakModel, completion: disableCompletion)
                }
            }))
        }
        
        // Notify the user and unlock the notification service
        WindowService.window()?.presentAlert(.standbyModeEnabled)
        notificationService.lock()
    }
    
    @MainActor
    func disableStandbyMode(_ modelContext: ModelContext, streakModel: StreakViewModel, completion: (() -> Void)? = nil) async {
        // Unfreeze the weekly streak
        streakModel.isStreakFreezed = false
        
        // Unlock the notification service
        let notificationService = NotificationService.shared
        notificationService.unlock()
        
        // Restore all notifications
        updateCurrentPlanning(modelContext)
        if let currentPlanning {
            notificationService.updateAllNotifications(for: currentPlanning)
        }
        let reminders = try? modelContext.fetch(Reminder.descriptor())
        for reminder in reminders?.filter({ Date(timeIntervalSinceReferenceDate: $0.deadlineTimeIntervalSinceReferenceDate) > Date() }) ?? [] {
            reminder.updateNotification(active: true)
        }
        
        // Remove the standby notification
        notificationService.removeNotifications(with: [Keys.standbyNotification])
        
        completion?()
    }
}


// Keys
private extension PlannerViewModel {
    class Keys {
        static let currentPlanningID = "CURRENT_PLANNING_IDENTIFIER"
        static let standbyNotification = "STANDBY_NOTIFICATION"
    }
}

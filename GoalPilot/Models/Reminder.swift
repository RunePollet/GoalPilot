//
//  Reminder.swift
//  GoalPilot
//
//  Created by Rune Pollet on 14/09/2024.
//

import SwiftUI
import SwiftData
import UserNotifications

/// An object which describes a reminder and from which values a UNNotificationRequest can be extracted.
@Model
final class Reminder: NotificationRepresentable, PlanningEvent, Persistentable {
    var id: UUID
    var dayIdentifier: String
    var title: String
    var subtitle: String
    var body: String
    var isEnabled: Bool
    var deadlineTimeIntervalSinceReferenceDate: Double
    var isDeleted: Bool
    var parent: Goal?
    
    // Color
    var colorRed: CGFloat
    var colorGreen: CGFloat
    var colorBlue: CGFloat
    var colorAlpha: CGFloat
    var defaultColorRawValue: Int?
    
    init() {
        self.id = UUID()
        self.dayIdentifier = Date.now.dayID
        self.title = "Reminder"
        self.subtitle = ""
        self.body = ""
        self.isEnabled = true
        self.deadlineTimeIntervalSinceReferenceDate = Date.now.timeIntervalSinceReferenceDate
        self.isDeleted = false
        self.colorRed = 0
        self.colorGreen = 0
        self.colorBlue = 0
        self.colorAlpha = 0
        self.defaultColorRawValue = DefaultColor.random().rawValue
    }
    
    
    // MARK: Fetch Support
    /// Returns a fetch descriptor to fetch all notifications for a given dayID ordered from earliest to latest.
    static func descriptor(forDayID dayID: String) -> FetchDescriptor<Reminder> {
        let predicate = #Predicate<Reminder> { $0.dayIdentifier == dayID && !$0.isDeleted }
        let earliestFirst = SortDescriptor(\Reminder.deadlineTimeIntervalSinceReferenceDate, order: .forward)
        return FetchDescriptor<Reminder>(predicate: predicate, sortBy: [earliestFirst])
    }
    
    /// Retrieves all reminders with the given day identifier.
    static func getAll(withDayID dayID: String, from modelContext: ModelContext) -> [Reminder] {
        return (try? modelContext.fetch(Self.descriptor(forDayID: dayID))) ?? []
    }
    
    
    // MARK: Notification Representable
    var displayedDateComponents: DatePickerComponents { [.date, .hourAndMinute] }
    var trigger: UNNotificationTrigger {
        UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents(in: .current, from: refDeadline), repeats: false)
    }
    
    
    // MARK: Planning Event
    var refDeadline: Date {
        get { Date(timeIntervalSinceReferenceDate: deadlineTimeIntervalSinceReferenceDate) }
        set {
            deadlineTimeIntervalSinceReferenceDate = newValue.timeIntervalSinceReferenceDate
            dayIdentifier = newValue.dayID
        }
    }
    
    static func referenceDate(for date: Date) -> Date {
        return date
    }
    
    static func eventDescriptor(planning: Planning? = nil, weekday: Int? = nil) -> FetchDescriptor<Reminder> {
        guard let weekday else { return .empty }
        let dayID = Calendar.current.nextDate(after: .now, matching: .init(weekday: weekday), matchingPolicy: .nextTime)?.dayID
        guard let dayID else { return .empty }
        return descriptor(forDayID: dayID)
    }
    
    
    // MARK: Persistentable
    func preDeletion(_ modelContext: ModelContext) {
        let id = id
        DispatchQueue.main.async {
            NotificationService.shared.removeNotifications(with: [id.uuidString])
        }
    }
    
    var isConfigured: Bool { !subtitle.isEmpty && parent != nil }
}

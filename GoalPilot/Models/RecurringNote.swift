//
//  RecurringNote.swift
//  GoalPilot
//
//  Created by Rune Pollet on 24/08/2024.
//

import SwiftUI
import SwiftData
import UserNotifications

/// An object which describes a recurring note and from which values a UNNotificationRequest can be extracted. A recurring note recurs weekly and is planning- and day-specific.
@Model
final class RecurringNote: NotificationRepresentable, PlanningEvent, Persistentable {
    var id: UUID
    var title: String
    var subtitle: String
    var body: String
    var isEnabled: Bool
    var isDeleted: Bool
    
    var _parent: Planning?
    var parent: Planning? {
        get { _parent?.activeValue }
        set { _parent = newValue }
    }
    
    // Deadline components
    var weekday: Int
    var hour: Int
    var minute: Int
    
    // Color
    var colorRed: CGFloat
    var colorGreen: CGFloat
    var colorBlue: CGFloat
    var colorAlpha: CGFloat
    var defaultColorRawValue: Int?
    
    init(weekday: Int) {
        self.id = UUID()
        self.title = "Note"
        self.subtitle = ""
        self.body = ""
        self.isEnabled = true
        self.isDeleted = false
        self.weekday = weekday
        self.hour = Calendar.current.dateComponents([.hour], from: .now).hour!
        self.minute = Calendar.current.dateComponents([.minute], from: .now).minute!
        self.colorRed = 0
        self.colorGreen = 0
        self.colorBlue = 0
        self.colorAlpha = 0
        self.defaultColorRawValue = DefaultColor.random().rawValue
    }
    
    
    // MARK: Fetch Support
    /// Retrieves all recurring notes with the given day identifier.
    static func getAll(ofPlanning planning: Planning? = nil, onWeekday weekday: Int? = nil, from modelContext: ModelContext) -> [RecurringNote] {
        return (try? modelContext.fetch(Self.eventDescriptor(planning: planning, weekday: weekday))) ?? []
    }
    
    
    // MARK: Notification Representable
    var displayedDateComponents: DatePickerComponents { .hourAndMinute }
    var trigger: UNNotificationTrigger {
        let deadline = DateComponents(hour: hour, minute: minute, weekday: weekday)
        return UNCalendarNotificationTrigger(dateMatching: deadline, repeats: true)
    }
    
    
    // MARK: Planning Event
    var refDeadline: Date {
        get {
            Calendar.current.date(from: DateComponents(hour: hour, minute: minute, weekday: weekday)) ?? .now
        }
        set {
            let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            hour = components.hour!
            minute = components.minute!
        }
    }
    
    static func referenceDate(for date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .weekday], from: date)
        return calendar.date(from: components) ?? date
    }
    
    static func eventDescriptor(planning: Planning?, weekday: Int? = nil) -> FetchDescriptor<RecurringNote> {
        guard let planning else { return .empty }
        
        let planningID = planning.persistentModelID
        var predicate: Predicate<RecurringNote> {
            if let weekday {
                return #Predicate<RecurringNote> {
                    $0._parent?.persistentModelID == planningID && $0.weekday == weekday && !$0.isDeleted
                }
            } else {
                return #Predicate<RecurringNote> {
                    $0._parent?.persistentModelID == planningID && !$0.isDeleted
                }
            }
        }
        
        let earliestHourFirst = SortDescriptor(\RecurringNote.hour, order: .forward)
        let earliestMinuteFirst = SortDescriptor(\RecurringNote.minute, order: .forward)
        
        return FetchDescriptor<RecurringNote>(predicate: predicate, sortBy: [earliestHourFirst, earliestMinuteFirst])
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

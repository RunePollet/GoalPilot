//
//  Activity.swift
//  GoalPilot
//
//  Created by Rune Pollet on 16/06/2024.
//
//

import SwiftUI
import SwiftData

@Model
final class Activity: RecurringPlanningEvent, NotificationRepresentable, Persistentable, Duplicatable {
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
    
    // Start Time & End Time
    var weekday: Int
    var startHour: Int
    var startMinute: Int
    var endHour: Int
    var endMinute: Int
    
    // Color
    var colorRed: CGFloat
    var colorGreen: CGFloat
    var colorBlue: CGFloat
    var colorAlpha: CGFloat
    var defaultColorRawValue: Int?
    
    init(weekday: Int) {
        self.id = UUID()
        self.title = "Activity"
        self.subtitle = ""
        self.body = ""
        self.isEnabled = true
        self.isDeleted = false
        self.colorRed = 0
        self.colorGreen = 0
        self.colorBlue = 0
        self.colorAlpha = 0
        self.defaultColorRawValue = DefaultColor.random().rawValue
        self.weekday = weekday
        
        // Set start and end time
        let start = Calendar.current.dateComponents([.hour], from: .now)
        let end = Calendar.current.dateComponents([.hour], from: .now.addingTimeInterval(3600))
        self.startHour = (start.hour ?? 8) + 1
        self.startMinute = 0
        self.endHour = (end.hour ?? 9) + 1
        self.endMinute = 0
    }
    
    
    // MARK: Accessibilities
    var startTimeComponents: DateComponents {
        get { DateComponents(hour: startHour, minute: startMinute, weekday: weekday) }
        set {
            self.startHour = newValue.hour ?? 9
            self.startMinute = newValue.minute ?? 41
        }
    }
    
    var endTimeComponents: DateComponents {
        get { DateComponents(hour: endHour, minute: endMinute, weekday: weekday) }
        set {
            self.endHour = newValue.hour ?? 9
            self.endMinute = newValue.minute ?? 41
        }
    }
    
    /// Returns a boolean indicating wether the reference date has passed the activity.
    func timeIntervalHasPassed() -> Bool {
        let now = Calendar.current.dateComponents([.weekday, .hour, .minute], from: .now)
        var isSameDay: Bool {
            guard let weekday = now.weekday, let endWeekday = endTimeComponents.weekday else { return true }
            return weekday == endWeekday
        }
        var dayHasPassed: Bool {
            guard let weekday = now.weekday, let endWeekday = endTimeComponents.weekday else { return true }
            return weekday > endWeekday
        }
        var hourHasPassed: Bool {
            guard let hour = now.hour, let endHour = endTimeComponents.hour else { return true }
            return hour >= endHour
        }
        var minuteHasPassed: Bool {
            guard let minute = now.minute, let endMinute = endTimeComponents.minute else { return true }
            return minute > endMinute
        }
        
        return dayHasPassed || (isSameDay && hourHasPassed && minuteHasPassed)
    }
    
    
    // MARK: Fetch Support
    /// Retrieves all activities with the given day identifier.
    static func getAll(ofPlanning planning: Planning? = nil, onWeekday weekday: Int? = nil, from modelContext: ModelContext) -> [Activity] {
        return (try? modelContext.fetch(Self.eventDescriptor(planning: planning, weekday: weekday))) ?? []
    }
    
    
    // MARK: Planning Event
    var refDeadline: Date {
        get { Calendar.current.date(from: startTimeComponents) ?? .now }
        set { startTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: newValue) }
    }
    
    var refEnd: Date? {
        get { Calendar.current.date(from: endTimeComponents) ?? .now }
        set {
            if let newValue {
                endTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            }
        }
    }
    
    static func referenceDate(for date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .weekday], from: date)
        return calendar.date(from: components) ?? date
    }
    
    static func eventDescriptor(planning: Planning?, weekday: Int? = nil) -> FetchDescriptor<Activity> {
        guard let planning else { return .empty }
        
        let planningId = planning.id
        var predicate: Predicate<Activity> {
            if let weekday {
                return #Predicate<Activity> {
                    $0._parent?.id == planningId && $0.weekday == weekday && !$0.isDeleted
                }
            } else {
                return #Predicate<Activity> {
                    $0._parent?.id == planningId && !$0.isDeleted
                }
            }
        }
        
        let earliestHourFirst = SortDescriptor(\Activity.startHour, order: .forward)
        let earliestMinuteFirst = SortDescriptor(\Activity.startMinute, order: .forward)
        
        return FetchDescriptor<Activity>(predicate: predicate, sortBy: [earliestHourFirst, earliestMinuteFirst])
    }
    
    
    // MARK: Notification Representable
    var displayedDateComponents: DatePickerComponents { .hourAndMinute }
    var trigger: UNNotificationTrigger {
        UNCalendarNotificationTrigger(dateMatching: startTimeComponents, repeats: true)
    }
    
    @MainActor
    func getRequest() -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = TextService.shared.motivatingExclamations.randomElement() ?? "Let's do this!"
        content.sound = .default
        
        return .init(identifier: id.uuidString, content: content, trigger: trigger)
    }
    
    @MainActor
    func updateNotification(active: Bool) {
        if isEnabled && active {
            NotificationService.shared.add(request: getRequest())
        } else {
            NotificationService.shared.removeNotifications(with: [id.uuidString])
        }
    }
    
    
    // MARK: Persistentable
    var isConfigured: Bool { !subtitle.isEmpty && parent != nil }
    
    func preDeletion(_ modelContext: ModelContext) {
        let id = id
        DispatchQueue.main.async {
            NotificationService.shared.removeNotifications(with: [id.uuidString])
        }
    }
    
    static func descriptor() -> FetchDescriptor<Activity> {
        let predicate = #Predicate<Activity> { !$0.isDeleted }
        return FetchDescriptor(predicate: predicate)
    }
    
    
    // MARK: Duplicatable
    func duplicate() -> Activity {
        let duplicate = Activity(weekday: self.weekday)
        duplicate.title = self.title
        duplicate.subtitle = self.subtitle
        duplicate.body = self.body
        duplicate.isEnabled = self.isEnabled
        duplicate.isDeleted = self.isDeleted
        duplicate._parent = self._parent
        duplicate.colorRed = self.colorRed
        duplicate.colorGreen = self.colorGreen
        duplicate.colorBlue = self.colorBlue
        duplicate.colorAlpha = self.colorAlpha
        duplicate.defaultColorRawValue = self.defaultColorRawValue
        duplicate.startHour = self.startHour
        duplicate.startMinute = self.startMinute
        duplicate.endHour = self.endHour
        duplicate.endMinute = self.endMinute
        return duplicate
    }
}

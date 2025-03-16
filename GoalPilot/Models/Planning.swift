//
//  Planning.swift
//  GoalPilot
//
//  Created by Rune Pollet on 16/06/2024.
//
//

import SwiftData

@Model
final class Planning: Persistentable {
    var title: String 
    var info: String?
    var isDeleted: Bool
    
    var _parent: Milestone?
    var parent: Milestone? {
        get { _parent?.activeValue }
        set { _parent = newValue }
    }
    
    @Relationship(deleteRule: .cascade, inverse: \RecurringNote._parent)
    var _recurringNotes: [RecurringNote]
    var recurringNotes: [RecurringNote] {
        get { isDeleted ? [] : _recurringNotes.filter { !$0.isDeleted } }
        set { _recurringNotes = newValue }
    }
    
    @Relationship(deleteRule: .cascade, inverse: \Activity._parent)
    var _activities: [Activity]
    var activities: [Activity] {
        get { isDeleted ? [] : _activities.filter { !$0.isDeleted } }
        set { _activities = newValue }
    }
    
    init(title: String, info: String? = nil) {
        self.title = title
        self.info = info
        self.isDeleted = false
        self._activities = []
        self._recurringNotes = []
    }
    
    
    // MARK: Fetch Support
    /// Fetches the planning for achieving the first milestone that the user hasn't achieved yet or a previous if nil.
    static func latest(from modelContext: ModelContext) -> Planning? {
        let milestones = Milestone.getAll(from: modelContext)
        let currentMilestone = milestones.last { !$0.achieved }
        
        if let planning = currentMilestone?.planning?.activeValue {
            return planning
        } else {
            let previousMilestone = milestones.last { $0.planning != nil }
            return previousMilestone?.planning?.activeValue
        }
    }
    
    /// Returns all relevant plannings.
    static func getAll(from modelContext: ModelContext) -> [Planning] {
        let result = (try? modelContext.fetch(Planning.descriptor())) ?? []
        return result
    }
    
    /// Returns all notifications and activities currently going on.
    func currentActivities() -> [Activity] {
        let ref = Activity.referenceDate(for: .now)
        return activities.filter { $0.refDeadline <= ref && ref <= $0.refEnd! }
    }
    
    /// Returns all events of this planning and any reminders for the given day sorted from earliest to latest.
    func getAllEvents(forWeekday weekday: Int? = nil, dayID: String? = nil, from modelContext: ModelContext) -> [any PlanningEvent] {
        let activities = Activity.getAll(ofPlanning: self, onWeekday: weekday, from: modelContext)
        let notifications = RecurringNote.getAll(ofPlanning: self, onWeekday: weekday, from: modelContext)
        var reminders = [Reminder]()
        if let dayID { reminders = Reminder.getAll(withDayID: dayID, from: modelContext) }
        
        let items: [any PlanningEvent] = activities + notifications + reminders
        return items.sorted { $0.refDeadline < $1.refDeadline }
    }
    
    
    // MARK: Persistentable
    var isConfigured: Bool { !title.isEmpty && parent != nil }
}

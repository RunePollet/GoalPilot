//
//  PlanningEventSummary.swift
//  GoalPilot
//
//  Created by Rune Pollet on 13/07/2024.
//

import SwiftUI
import SwiftData

/// A summary of all the given planning events.
struct PlanningEventSummary: View {
    @Environment(PlannerViewModel.self) private var plannerModel
    @Environment(NavigationViewModel.self) private var navigationModel
    @Environment(StreakViewModel.self) private var streakModel
    
    var showDoneButtons: Bool
    
    // Accessibiltiy
    var activities: [Activity]?
    var recurringNotes: [RecurringNote]?
    var reminders: [Reminder]?
    private var total: Int {
        (activities?.count ?? 0) + (recurringNotes?.count ?? 0) + (reminders?.count ?? 0)
    }
    
    // Navigation
    @State private var showEditSheetFor: Activity?
    @State private var editRecurringNote: RecurringNote?
    @State private var editReminder: Reminder?
    
    var body: some View {
        StackedPlanningEventSummary {
            // Activities
            if let activities, !activities.isEmpty {
                Section("Activities") {
                    ForEach(activities) { activity in
                        ActivityTile(activity: activity, canBeCompleted: showDoneButtons && !streakModel.completedActivities.contains(activity.id), isEditing: navigationModel.isEditing) {
                            if let currentPlanning = plannerModel.currentPlanning {
                                streakModel.enlistAsCompleted(activity: activity, currentPlanning: currentPlanning)
                            }
                        }
                        .editable(isEditing: navigationModel.isEditing || navigationModel.isCreating) {
                            showEditSheetFor = activity
                        }
                    }
                }
            }
            
            // Notifications
            if let recurringNotes, !recurringNotes.isEmpty {
                Section("Notes") {
                    ForEach(recurringNotes) { recurringNote in
                        NotificationTile(notification: recurringNote, isEditing: navigationModel.isEditing)
                            .editable(isEditing: navigationModel.isEditing || navigationModel.isCreating) {
                                editRecurringNote = recurringNote
                            }
                    }
                }
            }
            
            // Reminders
            if let reminders, !reminders.isEmpty {
                Section("Reminders") {
                    ForEach(reminders) { reminder in
                        NotificationTile(notification: reminder, isEditing: navigationModel.isEditing)
                            .editable(isEditing: navigationModel.isEditing || navigationModel.isCreating) {
                                editReminder = reminder
                            }
                    }
                }
            }
            
            // No events message
            if (activities?.isEmpty ?? true) && (recurringNotes?.isEmpty ?? true) && (reminders?.isEmpty ?? true) {
                Text("No events here")
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
                    .padding(.top)
            }
        }
        .onChange(of: total) { oldValue, newValue in
            if newValue == 0 {
                withAnimation {
                    navigationModel.isEditing = false
                }
            }
        }
        .sheet(item: $showEditSheetFor) { activity in
            NavigationModelStack {
                EditActivityView(activity: activity)
            }
        }
        .sheet(item: $editRecurringNote) { notification in
            NavigationModelStack {
                EditNotificationView(notification: notification)
            }
        }
        .sheet(item: $editReminder) { reminder in
            NavigationModelStack {
                EditNotificationView(notification: reminder)
            }
        }
    }
}

//
//  ReminderSettings.swift
//  GoalPilot
//
//  Created by Rune Pollet on 25/01/2025.
//

import SwiftUI

/// A list of all reminders to edit.
struct ReminderSettings: View {
    @Environment(NavigationViewModel.self) private var navigationModel
    
    @State private var createReminder = false
    
    var body: some View {
        NotificationSettings(forType: Reminder.self, title: "Reminders", missingNotificationsTitle: "Missing reminders", createNewTitle: "Create reminder", createNew: $createReminder)
            .navigationDestination(for: Reminder.self) { reminder in
                NavigationModelStack {
                    EditNotificationView(notification: reminder)
                }
            }
            .editToolbar(showEditButton: !navigationModel.hideEditButton, showAddButton: true) {
                createReminder = true
            }
            .sheet(isPresented: $createReminder) {
                NavigationModelStack(isCreating: true) {
                    CreateReminderView()
                }
            }
    }
}

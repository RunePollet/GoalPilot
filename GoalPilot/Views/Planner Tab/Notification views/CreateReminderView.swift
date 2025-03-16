//
//  CreateReminderView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 25/08/2024.
//

import SwiftUI

/// Creates a notification.
struct CreateReminderView: View {
    @Environment(Goal.self) private var goal
    @Environment(PlannerViewModel.self) private var plannerModel
    @Environment(NavigationViewModel.self) private var navigationModel
    
    @State private var reminder = Reminder()
    
    var body: some View {
        NotificationForm(wrapper: ObservableModel(reminder), date: plannerModel.currentDate, isCreating: navigationModel.isCreating)
            .navigationTitle("Add Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .modelInserter(model: reminder, insertCompletion: {
                reminder.parent = goal
            }, doneCompletion: {
                reminder.updateNotification(active: true)
            })
    }
}


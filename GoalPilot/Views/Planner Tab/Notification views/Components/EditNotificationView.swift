//
//  EditNotificationView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 25/08/2024.
//

import SwiftUI

/// Lets the user edit the details of a notification.
struct EditNotificationView<T: NotificationRepresentable & PlanningEvent & Persistentable>: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(PlannerViewModel.self) private var plannerModel
    @Environment(NavigationViewModel.self) private var navigationModel
    
    var notification: T
    
    var body: some View {
        NotificationForm(wrapper: ObservableModel(notification), date: plannerModel.currentDate, isCreating: navigationModel.isCreating)
            .navigationTitle(notification.subtitle)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar { DoneToolbarItems() }
            .onDisappear {
                if notification is Reminder {
                    notification.updateNotification(active: true)
                } else if let planning = (notification as? RecurringNote)?.parent as? Planning {
                    notification.updateNotification(active: planning == plannerModel.currentPlanning)
                }
            }
    }
}

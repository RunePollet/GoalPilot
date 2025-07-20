//
//  NotificationSettings.swift
//  GoalPilot
//
//  Created by Rune Pollet on 14/09/2024.
//

import SwiftUI
import SwiftData

/// A list of all notifications of a type to edit.
struct NotificationSettings<T: NotificationRepresentable & PlanningEvent & Persistentable>: View {
    var forType: T.Type
    var title: String
    var missingNotificationsTitle: String
    var createNewTitle: String
    @Binding var createNew: Bool
    
    // Accessibility
    @Query(T.descriptor(), animation: .default) private var notifications: [T]
    
    // Navigation
    @State private var selectedNotification: T?
    
    var body: some View {
        if !notifications.isEmpty {
            Form {
                // Notifications
                Section {
                    ForEach(notifications) { notification in
                        @Bindable var n = notification
                        Toggle(notification.subtitle, isOn: .init(get: { n.isEnabled }, set: { n.isEnabled = $0 }))
                            .tint(.accentColor)
                            .drillIn { selectedNotification = notification }
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selectedNotification) { notification in
                NavigationModelStack {
                    EditNotificationView(notification: notification)
                }
            }
        } else {
            ContentMissingView(icon: "sparkle.magnifyingglass", title: missingNotificationsTitle, info: "Please create one to view it here.") {
                Button(createNewTitle) {
                    createNew = true
                }
            }
            .background(Color(uiColor: .systemGroupedBackground))
        }
    }
}

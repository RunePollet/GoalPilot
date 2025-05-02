//
//  NotificationTile.swift
//  GoalPilot
//
//  Created by Rune Pollet on 25/08/2024.
//

import SwiftUI

/// A summary of the given notification in a tile.
struct NotificationTile<T: NotificationRepresentable & PlanningEvent & Persistentable>: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    
    var notification: T
    var isEditing: Bool
    
    var body: some View {
        Tile(title: notification.subtitle,
             timeInterval: notification.refDeadline.formatted(date: .omitted, time: .shortened),
             color: notification.color,
             customSection: {
            customSection
        })
    }
    
    private var customSection: some View {
        Group {
            if notification is Reminder {
                TileDoneButton {
                    withAnimation {
                        (notification as! Reminder).delete(from: modelContext)
                    }
                }
                .foregroundStyle(colorScheme == .dark ? Color.black.opacity(0.6) : Color.secondary)
                .disabled(isEditing)
            }
        }
    }
}

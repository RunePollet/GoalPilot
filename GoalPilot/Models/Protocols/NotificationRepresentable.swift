//
//  NotificationRepresentable.swift
//  GoalPilot
//
//  Created by Rune Pollet on 02/11/2024.
//

import SwiftUI
import SwiftData
import UserNotifications

/// For models that represent a notification.
protocol NotificationRepresentable {
    var id: UUID { get set }
    var title: String { get set }
    var subtitle: String { get set }
    var body: String { get set }
    var isEnabled: Bool { get set }
    var trigger: UNNotificationTrigger { get }
    
    /// The components the views date picker must show to represent the deadline of this notification.
    var displayedDateComponents: DatePickerComponents { get }
    
    /// Returns the request created from this objects data.
    @MainActor
    func getRequest() -> UNNotificationRequest
    
    /// Adds a notification representing the objects data to the notification center if the notification is enabled and currently active.
    @MainActor
    func updateNotification(active: Bool)
}

// Default implementations
extension NotificationRepresentable {
    @MainActor
    func getRequest() -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        return UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
    }
    
    @MainActor
    func updateNotification(active: Bool) {
        if self.isEnabled && active {
            NotificationService.shared.add(request: getRequest())
        } else {
            NotificationService.shared.removeNotifications(with: [id.uuidString])
        }
    }
}

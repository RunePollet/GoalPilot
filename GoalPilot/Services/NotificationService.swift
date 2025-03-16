//
//  NotificationService.swift
//  GoalPilot
//
//  Created by Rune Pollet on 24/08/2024.
//

import UIKit
import UserNotifications

class NotificationService: NSObject, Persistent {
    private let notificationCenter = UNUserNotificationCenter.current()
    private var completions: [String: () -> Void] = [:]
    private(set) var locked = false
    
    @MainActor
    static let shared = NotificationService()
    private override init() {
        super.init()
        notificationCenter.delegate = self
        restore()
    }
    
    func save() {
        // Save the lock
        UserDefaults.standard.set(locked, forKey: Keys.locked)
    }
    
    func restore() {
        // Restore the lock
        locked = UserDefaults.standard.bool(forKey: Keys.locked)
    }
    
    func lock() {
        locked = true
    }
    
    func unlock() {
        locked = false
    }
    
    func requestAuthorization(_ completion: ((_ didAllow: Bool) -> Void)? = nil) {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
            if error == nil {
                completion?(didAllow)
            } else {
                print("Error requesting notification authorization from the user: \(error!.localizedDescription)")
            }
        }
    }
    
    func add(request: UNNotificationRequest, completion: (() -> Void)? = nil) {
        if !locked {
            // Add notification
            notificationCenter.getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .notDetermined:
                    // Ask authorization
                    self.requestAuthorization { didAllow in
                        if didAllow {
                            self.notificationCenter.add(request)
                        }
                    }
                case .denied:
                    return
                case .authorized:
                    self.notificationCenter.add(request)
                default:
                    return
                }
            }
            
            // Save the completion
            if completion != nil {
                let id = request.identifier
                self.completions[id] = completion!
            }
        }
    }
    
    @MainActor
    func addAllNotifications(for planning: Planning) {
        if !locked {
            let activities = planning.activities.filter(\.isEnabled)
            let recurringNotes = planning.recurringNotes.filter(\.isEnabled)
            
            for activity in activities {
                add(request: activity.getRequest())
            }
            
            for recurringNote in recurringNotes {
                add(request: recurringNote.getRequest())
            }
        }
    }
    
    func removeNotifications(with identifiers: [String]) {
        if !locked {
            notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
    func removeAllNotifications(for planning: Planning? = nil) {
        if !locked {
            if let planning {
                let ids = planning.activities.map(\.id.uuidString) + planning.recurringNotes.map(\.id.uuidString)
                removeNotifications(with: ids)
            } else {
                notificationCenter.removeAllPendingNotificationRequests()
            }
        }
    }
}

extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .list])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Run the appropriate completion
        let id = response.notification.request.identifier
        if let completion = self.completions[id] {
            completion()
        }
        completionHandler()
    }
}


// Keys
extension NotificationService {
    final class Keys {
        static let locked = "LOCKED"
    }
}

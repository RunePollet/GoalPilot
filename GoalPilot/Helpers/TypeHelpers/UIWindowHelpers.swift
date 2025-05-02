//
//  UIWindowHelpers.swift
//  GoalPilot
//
//  Created by Rune Pollet on 05/11/2024.
//

import SwiftUI
import SwiftData

extension UIWindow {
    /// Presents an alert instead of the presented view controller.
    @MainActor
    func presentAlert(_ alert: UIAlertController, canBeRepeated: Bool = true) {
        
        let hasShownAlert = UserDefaults.standard.bool(forKey: alert.title! + alert.message!)
        if !hasShownAlert {
            // Check if there is already a view controller presented
            if let presentedVC = self.rootViewController?.presentedViewController {
                // Dismiss the present alert and present this alert
                presentedVC.dismiss(animated: true) {
                    self.rootViewController?.present(alert, animated: true)
                }
            } else {
                // Present the alert
                self.rootViewController?.present(alert, animated: true)
            }
            
            // Set the flag
            if !canBeRepeated {
                UserDefaults.standard.set(true, forKey: alert.title! + alert.message!)
            }
        }
    }
}

// Default alerts
extension UIAlertController {
    /// Describes an error when the app failed to fetch essential data.
    static let essentialDataError: UIAlertController = {
        var alert = UIAlertController(title: "Error", message: "An error occurred trying to load essential data. Please restart the app to try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        return alert
    }()
    
    /// Tells the user that the goal isn't fully configured.
    static let goalNotConfigured: UIAlertController = {
        var alert = UIAlertController(title: "Oops", message: "Your goal isn't fully configured, please specify all required information.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        return alert
    }()
    
    static let duplicateTitle: UIAlertController = {
        let alert = UIAlertController(title: "Duplicate Title", message: "Please use another title.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        return alert
    }()
    
    static let standbyModeEnabled: UIAlertController = {
        let alert = UIAlertController(title: "Standby mode enabled", message: "Your weekly streak is freezed and all notifications are disabled for 3 weeks, by then you'll receive an encouraging notification to revise your decision.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        return alert
    }()
    
    static func disableStandbyMode(_ continueCompletion: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: "Disable standby mode", message: "Are you ready to disable standby mode?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            continueCompletion()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        return alert
    }
    
    static let keptGoingEncouragement: UIAlertController = {
        let alert = UIAlertController(title: "Well done!", message: "Remember, you've got it in you to achieve your goal and you deserve it! So give it your all!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Let's go!", style: .default))
        return alert
    }()
    
    static func deleteGoal(deleteCompletion: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: "Data will be lost", message: "If you continue, the data of your previous goal will be lost. You will be able to add new data for a new goal.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { _ in
            deleteCompletion()
        }))
        return alert
    }
}

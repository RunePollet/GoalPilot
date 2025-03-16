//
//  AppDelegate.swift
//  GoalPilot
//
//  Created by Rune Pollet on 15/01/2025.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        // Restrict orientation
        return .portrait
    }
}

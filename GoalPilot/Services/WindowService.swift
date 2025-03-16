//
//  WindowService.swift
//  GoalPilot
//
//  Created by Rune Pollet on 28/10/2024.
//

import SwiftUI

@MainActor
struct WindowService {
    static func window() -> UIWindow? {
        
        // Check if iOS 13 or higher is available
        if #available(iOS 13.0, *) {
            let firstScene: UIScene? = UIApplication.shared.connectedScenes.first
            if let w = firstScene as? UIWindowScene {
                return w.windows.filter { $0.isKeyWindow }[0]
            }
            return nil
        }
        else {
            return UIApplication.shared.keyWindow
        }
    }
    
    /// Returns the size of the entire screen.
    static func screenSize() -> CGSize {
        return window()?.frame.size ?? .zero
    }
    
    /// Returns the requested safe area.
    static func safeArea() -> UIEdgeInsets {
        return window()?.safeAreaInsets ?? .zero
    }
}

//
//  OnDismiss.swift
//  GoalPilot
//
//  Created by Rune Pollet on 05/02/2025.
//

import SwiftUI

struct OnDismissModifier: ViewModifier {
    var path: NavigationPath
    var completion: () -> Void
    
    @State private var pathCount: Int?
    
    func body(content: Content) -> some View {
        content
            .onChange(of: path.count) { oldValue, newValue in
                if (pathCount == nil && oldValue > newValue) || (pathCount != nil && newValue < pathCount!) {
                    completion()
                } else {
                    pathCount = oldValue
                }
            }
    }
}

extension View {
    /// Uses the NavigationViewModel to determine if the view is being dismissed and runs an action on this event.
    func onDismiss(path: NavigationPath, perform completion: @escaping () -> Void) -> some View {
        modifier(OnDismissModifier(path: path, completion: completion))
    }
}

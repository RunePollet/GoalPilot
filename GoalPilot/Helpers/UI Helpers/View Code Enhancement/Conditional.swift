//
//  Conditional.swift
//  GoalPilot
//
//  Created by Rune Pollet on 23/01/2025.
//

import SwiftUI

extension View {
    /// Conditonally applies modifiers.
    @ViewBuilder
    func conditional<T: View>(_ condition: Bool, compute: @escaping (Self) -> T) -> some View {
        if condition {
            compute(self)
        } else {
            self
        }
    }
}

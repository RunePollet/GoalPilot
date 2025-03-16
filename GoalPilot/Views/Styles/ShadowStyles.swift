//
//  ShadowStyles.swift
//  GoalPilot
//
//  Created by Rune Pollet on 25/03/2024.
//

import SwiftUI

// Predefined shadow styles
extension View {
    func tileShadow(hidden: Bool = false) -> some View {
        self.shadow(color: .black.opacity(hidden ? 0 : 0.1), radius: 10, x: 0, y: 0)
    }
}

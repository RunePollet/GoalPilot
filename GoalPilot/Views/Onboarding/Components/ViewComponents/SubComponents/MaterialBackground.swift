//
//  MaterialBackground.swift
//  GoalPilot
//
//  Created by Rune Pollet on 01/04/2024.
//

import SwiftUI

/// The material background for the onboarding sequence's elements.
struct MaterialBackground: View {
    var radius: CGFloat = 10
    var body: some View {
        RoundedRectangle(cornerRadius: radius)
            .foregroundStyle(.ultraThinMaterial)
    }
}

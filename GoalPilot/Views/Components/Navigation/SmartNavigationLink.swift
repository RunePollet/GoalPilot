//
//  SmartNavigationLink.swift
//  GoalPilot
//
//  Created by Rune Pollet on 27/10/2024.
//

import SwiftUI

/// A navigation link that can be inactive.
struct SmartNavigationLink<Label: View>: View {
    var isActive: Bool
    var tint: Color = .accentColor
    var value: any Hashable
    @ViewBuilder var label: Label
    
    var body: some View {
        if isActive {
            NavigationLink(value: value) { label }
                .foregroundStyle(.primary, tint)
        } else {
            label
        }
    }
}


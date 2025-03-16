//
//  Grabber.swift
//  GoalPilot
//
//  Created by Rune Pollet on 15/09/2024.
//

import SwiftUI

/// Symbolizes a dragging gesture..
struct Grabber: View {
    var body: some View {
        HStack(spacing: 5) {
            Divider()
            Image(systemName: "line.3.horizontal")
                .foregroundStyle(.secondary)
                .imageScale(.large)
        }
    }
}

//
//  TappableBackground.swift
//  GoalPilot
//
//  Created by Rune Pollet on 23/01/2025.
//

import SwiftUI

/// An invisible background that makes sure gestures are recognized everywhere.
struct TappableBackground: View {
    var body: some View {
        Color(uiColor: UIColor.systemBackground).opacity(0.001)
    }
}

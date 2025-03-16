//
//  SheetBackground.swift
//  GoalPilot
//
//  Created by Rune Pollet on 17/04/2024.
//

import SwiftUI

/// The background for sheets on the onboarding sequence.
struct SheetBackground: View {
    var body: some View {
        Color(AssetsCatalog.firstHillColorID)
            .ignoresSafeArea()
            .overlay(.thinMaterial)
    }
}

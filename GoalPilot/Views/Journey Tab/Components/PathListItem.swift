//
//  PathListItem.swift
//  GoalPilot
//
//  Created by Rune Pollet on 17/12/2024.
//

import SwiftUI

/// A default display of a planning without event details.
struct PathListItem: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var planning: Planning?
    
    var body: some View {
        HStack(spacing: 5) {
            Text(planning?.title ?? "Create Planning")
            if planning == nil {
                Image(systemName: "chevron.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 11)
            }
        }
        .foregroundStyle(Color.secondary)
        .padding(style: .itemRow)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .conditional(colorScheme == .dark) {
                    $0.foregroundStyle(.black.opacity(0.2))
                }
                .conditional(colorScheme != .dark) {
                    $0.foregroundStyle(.ultraThinMaterial)
                }
        }
    }
}

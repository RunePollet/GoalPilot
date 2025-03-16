//
//  Tile.swift
//  GoalPilot
//
//  Created by Rune Pollet on 29/08/2024.
//

import SwiftUI

/// A color styled tile suitable for planning events.
struct Tile<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var title: String
    var timeInterval: String
    var color: Color
    var customSection: () -> Content
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.black)
            
            Spacer()
            
            Text(timeInterval)
                .font(.system(size: 14))
                .foregroundStyle(colorScheme == .dark ? Color.black.opacity(0.6) : Color.secondary)
            
            customSection()
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
        .background(
            Capsule()
                .foregroundStyle(color)
                .tileShadow()
        )
    }
}

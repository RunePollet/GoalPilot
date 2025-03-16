//
//  SmallPlanningEventRow.swift
//  GoalPilot
//
//  Created by Rune Pollet on 28/11/2024.
//

import SwiftUI

/// Displays a planning event in one line.
struct SmallPlanningEventRow: View {
    var minimalist: Bool
    var color: Color
    var title: String
    var timestamp: String?
    
    init(minimalist: Bool = true, color: Color, title: String, timestamp: String? = nil) {
        self.minimalist = minimalist
        self.color = color
        self.title = title
        self.timestamp = timestamp
    }
    
    var body: some View {
        HStack(spacing: minimalist ? 5 : 10) {
            Text("●")
                .font(.system(size: 10 ))
                .foregroundStyle(color)
            Text(title)
                .font(.system(size: 12))
                .fontWeight(.bold)
                .foregroundStyle(minimalist ? .secondary : .primary)
            Spacer()
            if let timestamp, !minimalist {
                Text(timestamp)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }
        }
        .lineLimit(1)
    }
}


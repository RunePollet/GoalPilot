//
//  StackedPlanningEventSummary.swift
//  GoalPilot
//
//  Created by Rune Pollet on 15/10/2024.
//

import SwiftUI

/// A list for displaying a day summary.
struct StackedPlanningEventSummary<Content: View>: View {
    var isEditing: Bool = false
    @ViewBuilder var content: Content
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 26) {
                ForEach(sections: content) { section in
                    StackedPlanningEventSection(configuration: section, isEditing: isEditing)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

private struct StackedPlanningEventSection: View {
    
    var configuration: SectionConfiguration
    var isEditing: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header
            if !configuration.header.isEmpty {
                configuration.header
                    .font(.system(size: 15, weight: .semibold, design: .default))
                    .foregroundStyle(Color.secondary)
                    .padding(.vertical)
            }
            
            // Subviews
            ForEach(subviews: configuration.content) { subview in
                subview
            }
            
            // Footer
            if !configuration.footer.isEmpty {
                configuration.footer
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                    .padding(.leading, 20)
            }
        }
    }
}


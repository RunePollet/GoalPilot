//
//  PlanningTile.swift
//  GoalPilot
//
//  Created by Rune Pollet on 06/12/2024.
//

import SwiftUI
import SwiftData

/// A summary of the given planning in a tile.
struct PlanningTile: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var planning: Planning
    var showDetail: Bool
    var activityDoneAction: ((Activity) -> Void)?
    
    var body: some View {
        NavigationLink(value: JourneyTabView.SelectedPlanning(planning: planning, isCurrent: showDetail)) {
            if showDetail {
                // Show the current event on this planning
                DetailedPathListItem(planning: planning) { activity in
                    activityDoneAction?(activity)
                }
            } else {
                PathListItem(planning: planning)
            }
        }
        .buttonStyle(.plain)
    }
}

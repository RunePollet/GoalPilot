//
//  CreatePlanningView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 06/07/2024.
//

import SwiftUI
import SwiftData

/// Creates a planning.
struct CreatePlanningView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(PlannerViewModel.self) private var plannerModel
    @Environment(StreakViewModel.self) private var streakModel
    @Environment(NavigationViewModel.self) private var navigationModel
    
    var parent: Milestone
    
    @State private var planning = Planning(title: "")
    
    var body: some View {
        PlanningForm(planning: planning, isEditing: navigationModel.isEditing, isCreating: navigationModel.isCreating)
            .navigationTitle("Create Planning")
            .navigationBarTitleDisplayMode(.inline)
            .modelInserter(model: planning, delay: 0.5, insertCompletion: {
                planning.parent = parent
                planning.establishRelationship(for: \.parent, with: parent, within: modelContext)
            }, cancelCompletion: {
                plannerModel.updateCurrentPlanning(modelContext: modelContext, refreshNotifications: false)
            }, doneCompletion: {
                // Update all notifications
                let allPlannings = Planning.getAll(from: modelContext)
                if allPlannings.count == 1 && allPlannings.first == planning {
                    NotificationService.shared.addAllNotifications(for: planning)
                    plannerModel.updateCurrentPlanning(modelContext: modelContext, refreshNotifications: true)
                }
                
                // Present the streak updater if this is the first planning
                let plannings = try? modelContext.fetch(Planning.descriptor())
                if plannings?.count == 1 && streakModel.weeklyStreak == 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        streakModel.presentStarPowerup(fadeIn: true, isFirst: true)
                    }
                }
            })
    }
}

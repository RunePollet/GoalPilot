//
//  CreateMilestoneView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 10/07/2024.
//

import SwiftUI
import SwiftData

/// Creates a milestone.
struct CreateMilestoneView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(Goal.self) private var goal
    @Environment(PlannerViewModel.self) private var plannerModel
    @Environment(NavigationViewModel.self) private var navigationModel
    
    enum Row {
        case title, info, planning
    }
    
    @State private var milestone = Milestone()
    
    // Accessibility
    private var pillars: [Pillar] { milestone.pillars }
    @Query(Pillar.descriptor()) private var allPillars: [Pillar]
    
    // View coordination
    @State private var selectedRow: Self.Row?
    @State private var showCreatePlanningSheet = false
    
    var body: some View {
        MilestoneForm(milestone: milestone, isEditing: navigationModel.isEditing, isCreating: navigationModel.isCreating)
            .navigationTitle("Add Milestone")
            .navigationBarTitleDisplayMode(.inline)
            .modelInserter(model: milestone, delay: 0.5, insertCompletion: {
                milestone.parent = goal
            }, doneCompletion: {
                if goal.achieved {
                    goal.setAchieved(false, currentPlanning: plannerModel.currentPlanning)
                }
            })
            
    }
}

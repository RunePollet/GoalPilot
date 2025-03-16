//
//  MilestoneSettings.swift
//  GoalPilot
//
//  Created by Rune Pollet on 15/03/2025.
//

import SwiftUI

struct MilestoneSettings: View {
    @Environment(\.modelContext) private var modelContext
    
    // Navigation
    @State private var createMilestone = false
    @State private var createPlanningForMilestone: Milestone?
    
    var body: some View {
        MilestoneAndPlanningList(milestones: Milestone.getAll(from: modelContext), editable: true, selectPlanningOfMilestone: { milestone in
            if milestone.planning == nil {
                createPlanningForMilestone = milestone
            }
        })
        .padding(.top)
        .navigationTitle("Milestones & Plannings")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(uiColor: .systemGroupedBackground))
        .editToolbar(showEditButton: false, showAddButton: true) {
            createMilestone = true
        }
        .sheet(isPresented: $createMilestone) {
            NavigationModelStack(isCreating: true) {
                CreateMilestoneView()
            }
        }
        .sheet(item: $createPlanningForMilestone) { milestone in
            NavigationModelStack(isCreating: true) {
                CreatePlanningView(parent: milestone)
            }
        }
    }
}

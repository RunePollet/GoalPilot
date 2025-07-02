//
//  PlanningDetailView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 13/07/2024.
//

import SwiftUI
import SwiftData

/// Shows details about a pillar and lets the user edit them.
struct PlanningDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(PlannerViewModel.self) private var plannerModel
    @Environment(StreakViewModel.self) private var streakModel
    @Environment(NavigationViewModel.self) private var navigationModel
    
    var planning: Planning
    
    @State private var forceDismissTrigger: Bool = false
    
    var body: some View {
        @Bindable var navigationModel = navigationModel
        
        PlanningForm(planning: planning, isEditing: navigationModel.isEditing, isCreating: navigationModel.isCreating) {
            // Deletion
            if planning == plannerModel.currentPlanning {
                plannerModel.setCurrentPlanning(to: nil, using: modelContext)
                streakModel.resetWeek()
            }
            planning.delete(from: modelContext)
            forceDismissTrigger.toggle()
        }
        .navigationTitle(planning.title.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .editToolbar(isEditing: $navigationModel.isEditing, showEditButton: !navigationModel.hideEditButton, forceDismissTrigger: forceDismissTrigger)
    }
}

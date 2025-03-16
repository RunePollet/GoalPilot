//
//  CreateRequirement.swift
//  GoalPilot
//
//  Created by Rune Pollet on 01/01/2025.
//

import SwiftUI

/// Creates a requirement goal.
struct CreateRequirement: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Goal.self) private var goal
    @Environment(NavigationViewModel.self) private var navigationModel
    
    @State private var requirement = Requirement()
    
    var body: some View {
        RequirementForm(requirement: requirement, isEditing: navigationModel.isEditing, isCreating: navigationModel.isCreating)
            .navigationTitle("Add Requirement")
            .navigationBarTitleDisplayMode(.inline)
            .modelInserter(model: requirement, insertCompletion: {
                requirement.parent = goal
            })
    }
}

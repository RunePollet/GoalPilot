//
//  RequirementSettings.swift
//  GoalPilot
//
//  Created by Rune Pollet on 01/01/2025.
//

import SwiftUI
import SwiftData

/// List of all requirements to edit.
struct RequirementSettings: View {
    @Environment(NavigationViewModel.self) private var navigationModel
    
    @Query(Requirement.descriptor()) private var requirements: [Requirement]
    
    var body: some View {
        SettingsList(title: "Requirements", missingItemsTitle: "Missing requirements", createNewTitle: "Create requirement", items: requirements, rowTitle: { $0.title }, destination: { requirement in
            RequirementForm(requirement: requirement, isEditing: navigationModel.isEditing, isCreating: navigationModel.isCreating)
                .navigationTitle(requirement.title)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
                .toolbar { DoneToolbarItems() }
        }, createDestination: {
            NavigationModelStack(isCreating: true) {
                CreateRequirement()
            }
        })
        .onAppear {
            navigationModel.isEditing = true
        }
    }
}

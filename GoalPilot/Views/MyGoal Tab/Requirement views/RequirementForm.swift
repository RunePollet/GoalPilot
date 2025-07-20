//
//  RequirementForm.swift
//  GoalPilot
//
//  Created by Rune Pollet on 01/01/2025.
//

import SwiftUI

/// A form containing all data of a requirement.
struct RequirementForm: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var requirement: Requirement
    var isEditing: Bool
    var isCreating: Bool
    
    @State private var showRemoveDialog = false
    
    var body: some View {
        Form {
            // Title and description
            Section {
                TextField("Title", text: $requirement.title)
                TextField("Description", text: $requirement.info.boundString, axis: .vertical)
            }
            .labeledContentStyle(.plain)
            .foregroundStyle(.primary, Color.accentColor)
            
            // Remove button
            if isEditing && !isCreating {
                Button("Remove", role: .destructive) {
                    showRemoveDialog = true
                }
                .frame(maxWidth: .infinity)
            }
        }
        .confirmationDialog("", isPresented: $showRemoveDialog) {
            Button("Remove", role: .destructive) {
                requirement.delete(from: modelContext)
                dismiss()
            }
        }
    }
}

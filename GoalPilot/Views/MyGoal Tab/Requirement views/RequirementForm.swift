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
                NavigationLink(value: TextPropertyEditor<Requirement>.Model(root: requirement, keyPath: \.title, title: "Title")) {
                    LabeledContent("Title", value: requirement.title)
                }
                NavigationLink(value: TextPropertyEditor<Requirement>.Model(root: requirement, keyPath: \.info.boundString, title: "Description")) {
                    LabeledContent("Description", value: requirement.info.boundString)
                }
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
        .navigationDestination(for: TextPropertyEditor<Requirement>.Model.self) { model in
            TextPropertyEditor(model: model)
        }
        .confirmationDialog("", isPresented: $showRemoveDialog) {
            Button("Remove", role: .destructive) {
                requirement.delete(from: modelContext)
                dismiss()
            }
        }
    }
}

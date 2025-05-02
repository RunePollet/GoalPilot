//
//  ToolbarComponents.swift
//  GoalPilot
//
//  Created by Rune Pollet on 24/08/2024.
//

import SwiftUI

// MARK: Save & Cancel Toolbar
/// The default done button and if selected cancel button for a toolbar.
struct DoneToolbarItems: ToolbarContent {
    @Environment(\.dismiss) private var dismiss
    
    var showCancel: Bool = false
    var disableDone: Bool = false
    var color: Color = .accentColor
    var doneCompletion: (() -> Void)?
    var cancelCompletion: (() -> Void)?
    var dismissAction: (() -> Void)?
    
    var body: some ToolbarContent {
        // Save
        ToolbarItem(placement: .confirmationAction) {
            Button("Done") {
                doneCompletion?()
                if let dismissAction {
                    dismissAction()
                } else {
                    dismiss()
                }
            }
            .foregroundStyle(color)
            .disabled(disableDone)
        }
        
        // Cancel
        if showCancel {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    cancelCompletion?()
                    if let dismissAction {
                        dismissAction()
                    } else {
                        dismiss()
                    }
                }
                .foregroundStyle(color)
            }
        }
    }
}


// MARK: Edit Toolbar
/// The default edit and add button of a toolbar.
struct EditToolbarItems: ToolbarContent {
    var isEditing: Bool = false
    var showEditButton: Bool = true
    var showAddButton: Bool = false
    var color: Color = .accentColor
    var editAction: (() -> Void)?
    var addAction: (() -> Void)? = nil
    
    @State private var animate = false
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            // Edit Button
            if showEditButton {
                Button {
                    editAction?()
                } label: {
                    Image(systemName: isEditing ? "checkmark" : "pencil")
                        .symbolVariant(isEditing ? .circle.fill : .none)
                        .transaction { transaction in
                            if transaction.animation == nil {
                                transaction.disablesAnimations = true
                            }
                        }
                        .contentTransition(.symbolEffect(.replace))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                }
                .sensoryFeedback(.impact, trigger: isEditing)
            }
            
            // Add Button
            if showAddButton {
                Button {
                    addAction?()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

// Implement the EditToolbarItems as view modifier to add back button hidden functionality
struct EditToolbarModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var isEditing: Bool
    var showEditButton: Bool
    var showAddButton: Bool
    var color: Color
    var forceDismissTrigger: Bool
    var addAction: (() -> Void)?
    
    @State private var initiatedEditing: Bool = false
    private var hideBackButton: Bool {
        initiatedEditing && isEditing
    }
    
    init(isEditing: Binding<Bool>?, showEditButton: Bool, showAddButton: Bool, color: Color, forceDismissTrigger: Bool, addAction: (() -> Void)? = nil) {
        self._isEditing = isEditing ?? .constant(false)
        self.showEditButton = showEditButton
        self.showAddButton = showAddButton
        self.color = color
        self.addAction = addAction
        self.forceDismissTrigger = forceDismissTrigger
        self.initiatedEditing = initiatedEditing
    }
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(hideBackButton)
            .toolbar {
                EditToolbarItems(isEditing: isEditing, showEditButton: showEditButton, showAddButton: showAddButton, color: color, editAction: {
                    withAnimation(.smooth) {
                        isEditing.toggle()
                    }
                    
                    // Hide back button when this view initiated editing
                    initiatedEditing = isEditing
                }, addAction: addAction)
            }
            .onChange(of: isEditing) { oldValue, newValue in
                if !newValue && initiatedEditing {
                    initiatedEditing = false
                }
            }
            .onChange(of: forceDismissTrigger) {
                if initiatedEditing {
                    isEditing = false
                }
                dismiss()
            }
    }
}

extension View {
    /// A toolbar with the default edit and add button.
    func editToolbar(isEditing: Binding<Bool>? = nil, showEditButton: Bool = true, showAddButton: Bool = false, color: Color = .accentColor, forceDismissTrigger: Bool = false, addAction: (() -> Void)? = nil) -> some View {
        modifier(EditToolbarModifier(isEditing: isEditing, showEditButton: showEditButton, showAddButton: showAddButton, color: color, forceDismissTrigger: forceDismissTrigger, addAction: addAction))
    }
}

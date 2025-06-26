//
//  CreateRecurringNoteView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 24/08/2024.
//

import SwiftUI
import SwiftData

/// Creates an recurring note.
struct CreateRecurringNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(PlannerViewModel.self) private var plannerModel
    @Environment(NavigationViewModel.self) private var navigationModel
    
    @State var recurringNote: RecurringNote
    var parent: Planning
    
    var body: some View {
        NotificationForm(wrapper: ObservableModel(recurringNote), date: plannerModel.currentDate, isCreating: navigationModel.isCreating)
            .navigationTitle("Add Recurring Note")
            .navigationBarTitleDisplayMode(.inline)
            .modelInserter(model: recurringNote, delay: 0.5, insertCompletion: {
                recurringNote.establishRelationship(for: \.parent, with: parent, within: modelContext)
            })
    }
}


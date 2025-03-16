//
//  RecurringNoteSettings.swift
//  GoalPilot
//
//  Created by Rune Pollet on 25/01/2025.
//

import SwiftUI
import SwiftData

/// A list of all recurring notes to edit.
struct RecurringNoteSettings: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(PlannerViewModel.self) private var plannerModel
    @Environment(NavigationViewModel.self) private var navigationModel
    
    // View coordination
    @State private var selectedPlanning: Planning?
    @State private var selectedWeekday: Int?
    
    @State private var showPlanningDialog = false
    @State private var showWeekdayDialog = false
    @State private var createRecurringNote = false
    
    // Accessibility
    @Query(Planning.descriptor()) private var plannings: [Planning]
    
    var body: some View {
        NotificationSettings(forType: RecurringNote.self, title: "Recurring Notes", missingNotificationsTitle: "Missing notes", createNewTitle: "Create recurring note", createNew: $createRecurringNote)
            .editToolbar(showEditButton: !navigationModel.hideEditButton, showAddButton: true) {
                showPlanningDialog = true
            }
            .confirmationDialog("Which planning do you want to add a recurring note for?", isPresented: $showPlanningDialog, titleVisibility: .visible) {
                ForEach(plannings) { planning in
                    Button(planning.title) {
                        selectedPlanning = planning
                        showWeekdayDialog = true
                    }
                }
            }
            .confirmationDialog("Which day do you want to add a recurring note to?", isPresented: $showWeekdayDialog, titleVisibility: .visible) {
                ForEach(1..<8) { count in
                    Button(count.weekdayDescription?.capitalized ?? "") {
                        selectedWeekday = count
                        createRecurringNote = true
                    }
                }
            }
            .sheet(isPresented: $createRecurringNote) {
                if let selectedPlanning, let selectedWeekday {
                    NavigationModelStack(isCreating: true) {
                        CreateRecurringNoteView(recurringNote: .init(weekday: selectedWeekday), parent: selectedPlanning)
                    }
                }
            }
    }
}

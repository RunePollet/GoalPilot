//
//  DayDetailView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 13/07/2024.
//

import SwiftUI
import SwiftData

/// Shows events of a planning on a weekday and lets the user edit them.
struct DayDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(NavigationViewModel.self) private var navigationModel
    
    enum SheetContent: Int, Identifiable {
        case addActivity = 0, addRecurringNote
        var id: Int { self.rawValue }
    }
    
    var planning: Planning
    var weekday: Int
    
    // View coordination
    @State private var showDialog = false
    
    // Navigation
    @State private var sheet: SheetContent?
    
    // Accessibility
    @Query private var activities: [Activity]
    @Query private var recurringNotes: [RecurringNote]
    
    init(planning: Planning, weekday: Int) {
        self.planning = planning
        self.weekday = weekday
        self._activities = Query(Activity.eventDescriptor(planning: planning, weekday: weekday))
        self._recurringNotes = Query(RecurringNote.eventDescriptor(planning: planning, weekday: weekday))
    }
    
    var body: some View {
        @Bindable var navigationModel = navigationModel
        
        PlanningEventSummary(
            showDoneButtons: false,
            addNewEvent: { showDialog = true },
            activities: activities,
            recurringNotes: recurringNotes
        )
        .navigationTitle(weekday.weekdayDescription?.capitalized ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .editToolbar(isEditing: $navigationModel.isEditing, showEditButton: !navigationModel.hideEditButton && !(activities.isEmpty && recurringNotes.isEmpty) && !navigationModel.isCreating, showAddButton: true) {
            showDialog = true
        }
        .confirmationDialog("", isPresented: $showDialog) {
            Button("Add activity") {
                sheet = .addActivity
            }
            Button("Add recurring note") {
                sheet = .addRecurringNote
            }
        }
        .sheet(item: $sheet) { content in
            sheetView(content)
        }
    }
    
    private func sheetView(_ content: SheetContent) -> some View {
        NavigationModelStack(isCreating: true) {
            Group {
                switch content {
                case .addActivity:
                    CreateActivityView(activity: .init(weekday: weekday), parent: planning)
                case .addRecurringNote:
                    CreateRecurringNoteView(recurringNote: .init(weekday: weekday), parent: planning)
                }
            }
        }
    }
}

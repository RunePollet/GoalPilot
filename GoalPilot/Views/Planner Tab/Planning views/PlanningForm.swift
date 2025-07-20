//
//  PlanningForm.swift
//  GoalPilot
//
//  Created by Rune Pollet on 14/07/2024.
//

import SwiftUI
import SwiftData

/// A form containing all data of a planning.
struct PlanningForm: View {
    @Bindable var planning: Planning
    var isEditing: Bool
    var isCreating: Bool
    var delete: (() -> Void)?
    
    // View coordination
    @State private var showRemoveDialog = false
    @State private var name = ""
    
    // Accessibility
    @Query private var activities: [Activity]
    @Query private var recurringNotes: [RecurringNote]
    
    init(planning: Planning, isEditing: Bool, isCreating: Bool, delete: (() -> Void)? = nil) {
        self.planning = planning
        self.isEditing = isEditing
        self.isCreating = isCreating
        self.delete = delete
        self._activities = Query(Activity.eventDescriptor(planning: planning))
        self._recurringNotes = Query(RecurringNote.eventDescriptor(planning: planning))
    }
    
    var body: some View {
        @Bindable var planning = planning
        
        Form {
            // Title and description
            Section {
                TextField("Title", text: $planning.title)
                TextField("Description", text: $planning.info.boundString, axis: .vertical)
            }
            .labeledContentStyle(.plain)
            .disabled(!isEditing && !isCreating)
            
            // Days
            Section {
                ForEach(1..<8) { weekday in
                    NavigationLink(value: SelectedWeekday(weekday: weekday, planning: planning)) {
                        LabeledContent(weekday.weekdayDescription?.capitalized ?? "Oops... I guess this day doesn't exist", value: getEventCount(for: weekday))
                    }
                }
            } header: {
                Text("Days")
                    .foregroundStyle(.secondary)
            }
            .labeledContentStyle(.plain)
            .foregroundStyle(.primary, Color.accentColor)
            
            // Remove button
            if !isCreating && isEditing {
                Button("Remove", role: .destructive) {
                    showRemoveDialog = true
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationDestination(for: SelectedWeekday.self) { selection in
            DayDetailView(planning: selection.planning, weekday: selection.weekday)
        }
        .confirmationDialog("This action cannot be undone", isPresented: $showRemoveDialog) {
            Button("Remove", role: .destructive) {
                delete?()
            }
        }
    }
    
    func getEventCount(for weekday: Int) -> String {
        let activityCount = activities.filter { $0.weekday == weekday }.count
        let recurringNotesCount = recurringNotes.filter { $0.weekday == weekday }.count
        let eventCount = activityCount+recurringNotesCount
        return eventCount == 0 ? "" : eventCount.description
    }
}

extension PlanningForm {
    /// An object to use as navigation data when selecting a weekday.
    struct SelectedWeekday: Hashable {
        var weekday: Int
        var planning: Planning
    }
}

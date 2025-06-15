//
//  PlannerDayView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 21/10/2024.
//

import SwiftUI
import SwiftData

/// Shows the current day and its events according to the planner model.
struct PlannerDayView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(NavigationViewModel.self) private var navigationModel
    
    enum SheetContent: Int, Identifiable {
        case addActivity = 1, addRecurringNote, addReminder
        var id: Int { self.rawValue }
    }
    
    var plannerModel: PlannerViewModel
    
    // Navigation
    @State private var showAddDialog = false
    @State private var sheet: SheetContent?
    
    // Accessibility
    @Query private var activities: [Activity]
    @Query private var recurringNotes: [RecurringNote]
    @Query private var reminders: [Reminder]
    
    private let calendar = Calendar.current
    private var date: Date { plannerModel.currentDate }
    private var currentWeekday: Int { calendar.component(.weekday, from: date) }
    private var title: String {
        if date.isToday {
            return "Today"
        } else if date.isTomorrow {
            return "Tomorrow"
        } else if date.isYesterday {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE d MMM"
            return formatter.string(from: date)
        }
    }
    
    init(plannerModel: PlannerViewModel) {
        self.plannerModel = plannerModel
        
        let planning = plannerModel.currentPlanning
        if let planning {
            let date = plannerModel.currentDate
            let weekday = Calendar.current.component(.weekday, from: date)
            self._activities = Query(Activity.eventDescriptor(planning: planning, weekday: weekday))
            self._recurringNotes = Query(RecurringNote.eventDescriptor(planning: planning, weekday: weekday))
            self._reminders = Query(Reminder.descriptor(forDayID: date.dayID))
        } else {
            self._activities = Query(.empty)
            self._recurringNotes = Query(.empty)
            self._reminders = Query(.empty)
        }
    }
    
    var body: some View {
        @Bindable var navigationModel = navigationModel
        
        VStack(spacing: 0) {
            PlanningEventSummary(
                showDoneButtons: Calendar.current.dateComponents([.weekOfYear, .year], from: date) == Calendar.current.dateComponents([.weekOfYear, .year], from: .now),
                activities: activities,
                recurringNotes: recurringNotes,
                reminders: reminders
            )
            
            DayPicker(background: Color(uiColor: .systemGroupedBackground))
                .padding(.bottom, 5)
                .background(Color(uiColor: .systemGroupedBackground))
        }
        .navigationTitle(title)
        .editToolbar(isEditing: $navigationModel.isEditing, showEditButton: !navigationModel.hideEditButton, showAddButton: true) {
            showAddDialog = true
        }
        .confirmationDialog("", isPresented: $showAddDialog) {
            Button("Add activity") {
                sheet = .addActivity
            }
            Button("Add recurring note") {
                sheet = .addRecurringNote
            }
            Button("Add reminder") {
                sheet = .addReminder
            }
        }
        .sheet(item: $sheet) { content in
            sheet(content)
        }
    }
    
    private func sheet(_ content: SheetContent) -> some View {
        let weekday = Calendar.current.component(.weekday, from: date)
        return NavigationModelStack(isCreating: true) {
            Group {
                if let currentPlanning = plannerModel.currentPlanning {
                    switch content {
                    case .addActivity:
                        CreateActivityView(activity: .init(weekday: weekday), parent: currentPlanning)
                    case .addRecurringNote:
                        CreateRecurringNoteView(recurringNote: .init(weekday: weekday), parent: currentPlanning)
                    case .addReminder:
                        CreateReminderView()
                    }
                } else {
                    ContentMissingView(
                        icon: "text.magnifyingglass",
                        title: "Missing planning",
                        info:
                            """
                            Oops... it seems like you haven't selected or created a planning yet. To create one, please navigate to the 'Journey' tab and tap the 'Create Planning' button underneath the milestone you want to create it for. 
                            If this isn't the case, please contact me so we can fix this together!
                            """
                    ) {
                        if let url = URL(string: "https://goalpilot.be/contact-me/") {
                            Link("Contact me", destination: url)
                        }
                    }
                }
            }
        }
    }
}

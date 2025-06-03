//
//  SettingsView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 14/09/2024.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Goal.self) private var goal
    @Environment(GlobalViewModel.self) private var globalModel
    @Environment(PlannerViewModel.self) private var plannerModel
    @Environment(StreakViewModel.self) private var streakModel
    @Environment(NavigationViewModel.self) private var navigationModel
    
    enum Destination {
        case goal, pillars, milestonesAndPlannings, notifications, recurringNotes, name, appIcon
    }
    
    @AppStorage("STANDBY_MODE") private var enableStandby = false
    @State private var username = TextService.shared.username
    
    var body: some View {
        Form {
            Section {
                // Goal
                NavigationLink(value: Destination.goal) {
                    Text("My Goal")
                }
                
                // Pillars
                NavigationLink(value: Destination.pillars) {
                    Text("Pillars")
                }
                
                // Milestones & Plannings
                NavigationLink(value: Destination.milestonesAndPlannings) {
                    Text("Milestones & Plannings")
                }
            }
            
            Section {
                // Reminders
                NavigationLink(value: Destination.notifications) {
                    Text("Reminders")
                }
                
                // Recurring Notes
                NavigationLink(value: Destination.recurringNotes) {
                    Text("Recurring Notes")
                }
            }
            
            Section {
                // Name
                NavigationLink(value: Destination.name) {
                    LabeledContent("Name", value: username)
                }
                
                // App Icon
                NavigationLink(value: Destination.appIcon) {
                    Text("App Icon")
                }
            }
            
            // Standby mode
            Section {
                Toggle("Standby", isOn: $enableStandby)
                    .tint(Color.accentColor)
            } header: {
                Text("Standby Mode")
                    .foregroundStyle(Color.secondary)
            } footer: {
                Text("If you turn on standby mode, you're weekly streak will be freezed and you won’t get any notifications for 3 weeks. After 3 weeks you’ll get an encouraging notification.")
                    .foregroundStyle(Color.secondary)
            }
            
            // Website Links
            Section {
                Link("Give Feedback", destination: URL(string: "https://goalpilot.be/feedback/")!)
                Link("Share Your Dream", destination: URL(string: "https://goalpilot.be/whats-your-dream/")!)
                Link("Privacy Policy", destination: URL(string: "https://goalpilot.be/privacy-policy/")!)
            }
            .foregroundStyle(Color.accentColor)
        }
        .foregroundStyle(.primary, Color.accentColor)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Destination.self) { destination in
            self.destination(destination)
        }
        .onChange(of: enableStandby) { oldValue, newValue in
            if newValue {
                plannerModel.enableStandbyMode(modelContext, streakModel: streakModel) {
                    // Disable completion
                    enableStandby = false
                }
            } else {
                Task {
                    await plannerModel.disableStandbyMode(modelContext, streakModel: streakModel)
                    streakModel.isStreakFreezed = false
                }
            }
        }
        .onAppear {
            navigationModel.hideEditButton = true
            navigationModel.isEditing = true
        }
        .onDismiss(path: navigationModel.path) {
            navigationModel.hideEditButton = false
            navigationModel.isEditing = false
        }
    }
    
    @ViewBuilder
    private func destination(_ destination: Destination) -> some View {
        switch destination {
        case .goal:
            GoalDetailView()
        case .pillars:
            PillarSettings()
        case .milestonesAndPlannings:
            MilestoneSettings()
        case .notifications:
            ReminderSettings()
        case .recurringNotes:
            RecurringNoteSettings()
        case .name:
            UsernameEditor()
        case .appIcon:
            SelectAppIconView()
        }
    }
}

/// Represents the SettingsView destination in a NavigationPath.
struct SettingsDestination: Hashable {}

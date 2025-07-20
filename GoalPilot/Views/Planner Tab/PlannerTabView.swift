//
//  PlannerTabView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 01/06/2024.
//

import SwiftUI
import SwiftData

/// The main view for the Planner tab.
struct PlannerTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(GlobalViewModel.self) private var globalModel
    @Environment(PlannerViewModel.self) private var plannerModel
    
    var body: some View {
        Group {
            if let currentPlanning = plannerModel.currentPlanning {
                PlannerMonthView(planning: currentPlanning)
            } else {
                ContentMissingView(icon: "calendar.badge.exclamationmark", title: "Missing planning", info: "Please create a planning to view it here.") {
                    Button("Create planning") {
                        globalModel.showFirstPlanningCreationSheet()
                    }
                }
                .background(Color(uiColor: .systemGroupedBackground))
            }
        }
        .onAppear {
            plannerModel.updateCurrentPlanning(modelContext: modelContext, refreshNotifications: false)
        }
    }
}

//
//  EditActivityView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 14/07/2024.
//

import SwiftUI

/// Lets the user edit the details of an activity.
struct EditActivityView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(PlannerViewModel.self) private var plannerModel
    @Environment(NavigationViewModel.self) private var navigationModel
    
    var activity: Activity
    
    var body: some View {
        ActivityForm(activity: activity, date: plannerModel.currentDate, isCreating: navigationModel.isCreating)
            .navigationTitle(activity.subtitle)
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
            .toolbar {
                DoneToolbarItems(doneCompletion: {
                    if !navigationModel.isCreating {
                        activity.updateNotification(active: activity.parent != nil ? activity.parent == plannerModel.currentPlanning : false)
                    }
                })
            }
    }
}

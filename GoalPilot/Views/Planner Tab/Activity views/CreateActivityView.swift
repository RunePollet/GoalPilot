//
//  CreateActivityView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 14/07/2024.
//

import SwiftUI

/// Creates an activity.
struct CreateActivityView: View {
    @Environment(StreakViewModel.self) private var streakModel
    @Environment(PlannerViewModel.self) private var plannerModel
    @Environment(NavigationViewModel.self) private var navigationModel
    
    @State var activity: Activity
    var parent: Planning
    
    var body: some View {
        ActivityForm(activity: activity, date: plannerModel.currentDate, isCreating: navigationModel.isCreating)
            .navigationTitle("Add Activity")
            .navigationBarTitleDisplayMode(.inline)
            .modelInserter(model: activity, delay: 0.5, insertCompletion: {
                activity.parent = parent
            }, doneCompletion: {
                if let currentPlanning = plannerModel.currentPlanning {
                    streakModel.checkStreakIncreaser(currentPlanning: currentPlanning)
                }
            })
    }
}

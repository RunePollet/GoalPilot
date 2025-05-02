//
//  NotAchieveAnyoreView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 18/08/2024.
//

import SwiftUI

/// Motivational content to support the user when they want to give up their goal. Reason: They don't want it anymore.
struct NotAchieveAnymoreView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(PlannerViewModel.self) private var plannerModel
    @Environment(StreakViewModel.self) private var streakModel
    
    @State private var showSecondaryIcon = false
    @State private var showStandbyDialog = false
    
    var body: some View {
        MotivationalViewLayout(
            toolbar: .keepGoing,
            showSecondaryIcon: $showSecondaryIcon,
            icon: {
                Group {
                    if showSecondaryIcon {
                        ClearHeadIcon()
                            .transition(.scale.combined(with: .opacity))
                            .foregroundStyle(Color.green)
                    } else {
                        CloudInHeadIcon()
                            .transition(.scale.combined(with: .opacity))
                            .foregroundStyle(Color.gray)
                    }
                }
                .frame(width: pct(120/852, of: .height), height: pct(120/852, of: .height))
            },
            title: "Take your time",
            tabs: [
                ("You might feel like you don’t need to achieve your goal anymore. Maybe you don’t want to achieve what you described as your goal, or maybe you’re satisfied with your life right now, but that doesn’t have to mean you don’t have a dream anymore.", false, nil),
                ("We encourage you to take your time to reconsider this decision before acting on it. The following questions might help you: \n\n#Do I really want to stop the journey to my dream now? \nOr do I still want to achieve something?#", false, nil)
            ],
            dialogTitle: "Delete my goal",
            secondaryButton: ("I will revise my decision", { showStandbyDialog = true })
        )
        .padding(.top, pct(30/852, of: .height))
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Are you sure?")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .confirmationDialog("Do you want to enable standby mode to silence all notifications for a few weeks?", isPresented: $showStandbyDialog, titleVisibility: .visible) {
            Button("Yes") {
                enableStandbyMode()
            }
            
            Button("No", role: .cancel) {
                dismiss()
            }
        }
    }
    
    func enableStandbyMode() {
        plannerModel.enableStandbyMode(modelContext, streakModel: streakModel)
        dismiss()
    }
}

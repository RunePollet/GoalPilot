//
//  OtherView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 18/08/2024.
//

import SwiftUI

/// Motivational content to support the user when they want to give up their goal. Reason: Other.
struct OtherView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(PlannerViewModel.self) private var plannerModel
    
    @State private var showSecondaryIcon = false
    
    var body: some View {
        MotivationalViewLayout(
            toolbar: .keepGoing,
            showSecondaryIcon: $showSecondaryIcon, icon: {
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
            title: "Take a break",
            tabs: [
                ("If you feel like giving up, like you don’t want to work for your dream anymore for whatever reason you may have, wouldn’t be a good idea to take a break?", false, nil),
                ("Instead of giving up, #take a break from executing your plan#, take some time off. For a few weeks, don’t think about your dream and come back when your mind is clear.", false, nil),
                ("#Then ask yourself again if you still want to give up#.\n\nYou can turn on standby mode so you won’t get any notifications for 3 weeks. After 3 weeks you’ll get an encouraging notification to reconsider.", false, nil)
            ],
            dialogTitle: "Give up",
            secondaryButton: ("Activate standby mode", enableStandbyMode)
        )
        .padding(.top, pct(30/852, of: .height))
        .background(Color(uiColor: .systemGroupedBackground))
    }
    
    func enableStandbyMode() {
        plannerModel.enableStandbyMode(modelContext)
        dismiss()
    }
}

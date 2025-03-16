//
//  ChangeGoalView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 18/08/2024.
//

import SwiftUI

/// Motivational content to support the user when they want to change their goal.
struct ChangeGoalView: View {
    var body: some View {
        MotivationalViewLayout(
            toolbar: .cancel,
            icon: {
                ChangeThePlanIcon()
                    .foregroundStyle(.gray, .green.opacity(0.7))
                    .frame(width: pct(120/852, of: .height), height: pct(120/852, of: .height))
            },
            title: "Hold on!",
            labeledText: "Your life goal isn’t something that should be changed from time to time. \n\nIf you feel like you can’t achieve your goal, #change the plan#, never change the goal.",
            dialogTitle: "Change my goal"
        )
        .padding(.top, pct(30/852, of: .height))
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Are you sure?")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
}

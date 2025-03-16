//
//  ScaredOfFailureView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 18/08/2024.
//

import SwiftUI

/// Motivational content to support the user when they want to give up their goal. Reason: Scared of failure.
struct ScaredOfFailureView: View {
    @State private var showSecondaryIcon = false
    
    var body: some View {
        MotivationalViewLayout(
            toolbar: .keepGoing,
            showSecondaryIcon: $showSecondaryIcon,
            icon: {
                Group {
                    if showSecondaryIcon {
                        SuccessThroughFailureIcon()
                            .transition(.scale.combined(with: .opacity))
                            .foregroundStyle(Color.green)
                    } else {
                        FailureIcon()
                            .transition(.scale.combined(with: .opacity))
                            .foregroundStyle(Color.gray)
                    }
                }
                .font(.system(size: 12, design: .rounded))
                .frame(width: pct(120/852, of: .height), height: pct(120/852, of: .height))
            },
            title: "Failure is good",
            tabs: [
                ("“Don’t be afraid of failure, it’s not the end, it’s an opportunity.”", true, nil),
                ("You shouldn’t be afraid of failure, in fact, #failure is the way to success#. Perfection is achieved through failing multiple times and learning from it.", false, nil),
                ("So don’t be afraid to fail, try it and see what happens. #Either you succeed, or you fail and got an opportunity to improve and do it better next time#. \nWe encourage you to keep trying!", false, nil)
            ],
            dialogTitle: "Give up"
        )
        .padding(.top, pct(30/852, of: .height))
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

//
//  NoMotivationView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 18/08/2024.
//

import SwiftUI

/// Motivational content to support the user when they want to give up their goal. Reason: No motivation.
struct NoMotivationView: View {
    @State private var showSecondaryIcon = false
    
    var body: some View {
        MotivationalViewLayout(
            toolbar: .keepGoing,
            showSecondaryIcon: $showSecondaryIcon,
            icon: {
                Group {
                    if showSecondaryIcon {
                        ConsistencyIcon()
                            .transition(.scale.combined(with: .opacity))
                            .foregroundStyle(Color.green)
                    } else {
                        MotivationIcon()
                            .transition(.scale.combined(with: .opacity))
                            .foregroundStyle(Color.gray)
                    }
                }
                .font(.system(size: 12, design: .rounded))
                .frame(width: pct(200/852, of: .height), height: pct(200/852, of: .height))
            },
            title: "No motivation?\nCome on, just keep going!",
            tabs: [
                ("“The biggest threat to success is not failure, but boredom.”", true, ("Atomic Habits", "https://jamesclear.com")),
                ("“When your habits for achieving your goal become routine, they become less satisfying and less interesting. We become bored and lose motivation.”", false, ("Atomic Habits", "https://jamesclear.com")),
                ("This is one of the bottle-necks in the journey to your dream, and in this moment we encourage you to keep going! By doing so, proudness and motivation will come to you.", false, nil),
                ("#Try to train your self-discipline#, as you might need it even more than motivation.", false, nil)
            ],
            yOffset: -pct(70/852, of: .height),
            dialogTitle: "Give up"
        )
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

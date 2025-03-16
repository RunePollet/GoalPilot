//
//  TiredView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 18/08/2024.
//

import SwiftUI

/// Motivational content to support the user when they want to give up their goal. Reason: Tired.
struct TiredView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var showSecondaryIcon = false
    
    var body: some View {
        MotivationalViewLayout(
            toolbar: .keepGoing,
            showSecondaryIcon: $showSecondaryIcon, icon: {
                Group {
                    if showSecondaryIcon {
                        WorkRestIcon()
                            .transition(.scale.combined(with: .opacity))
                            .foregroundStyle(Color.green)
                    } else {
                        BurnOutIcon(background: Color(uiColor: colorScheme == .light ? .systemGroupedBackground : .black))
                            .transition(.scale.combined(with: .opacity))
                            .foregroundStyle(Color.gray)
                    }
                }
                .font(.system(size: 12, design: .rounded))
                .frame(width: pct(120/852, of: .height), height: pct(120/852, of: .height))
            },
            title: "Take time to rest,\nbut don’t give up",
            tabs: [
                ("“It’s more important to make sure you can keep going, than to go as fast as you can.”", true, nil),
                ("Instead of giving up, wouldn’t it be a better idea to take a break until you’re ready to go back at it again?", false, nil),
                ("#It’s ok to take a break, as long as you don’t forget your dream in the process#. And when you start again, it might be better to take another approach.", false, nil),
                ("#A work-cycle such as work>rest>work is better in the long term than work>work#. That is, if applied correctly: taking rest whenever needed, and not the other way around: doing work when needed. This work-cycle might ensure a more comfortable way of working and more steady progress.", false, nil)
            ],
            dialogTitle: "Give up"
        )
        .padding(.top, pct(30/852, of: .height))
        .background(Color(uiColor: colorScheme == .light ? .systemGroupedBackground : .black))
    }
}

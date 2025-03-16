//
//  NobodyBelievesInMeView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 18/08/2024.
//

import SwiftUI

/// Motivational content to support the user when they want to give up their goal. Reason: Nobody believes in me.
struct NobodyBelievesInMeView: View {
    @State private var showSecondaryIcon = false
    
    var body: some View {
        MotivationalViewLayout(
            toolbar: .keepGoing,
            showSecondaryIcon: $showSecondaryIcon, icon: {
                Group {
                    if showSecondaryIcon {
                        BelieveInYourselfIcon(showHeart: true)
                            .transition(.scale.combined(with: .opacity))
                            .foregroundStyle(Color.green)
                    } else {
                        BelieveInYourselfIcon(showHeart: false)
                            .transition(.scale.combined(with: .opacity))
                            .foregroundStyle(Color.gray)
                    }
                }
                .frame(width: pct(120/852, of: .height), height: pct(120/852, of: .height))
            },
            title: "Believe in yourself",
            tabs: [
                ("“The strongest power comes from yourself, not from others.”", true, nil),
                ("It’s common for people to worry about what others think and to depend on their opinion on them. But the key is to #have trust and belief in yourself#.", false, nil),
                ("Once you realize that #you are the only person needed to achieve what you want, and only your opinion is relevant to you#, it will be far easier to keep going even when no one believes in you. ", false, nil),
                ("The people surrounding you can give you lots of power to keep going, but don’t forget that you can give yourself such power as well, maybe even more😉. Just remember:\n\n#“You do have the strength to achieve your dreams.”#", false, nil)
            ],
            dialogTitle: "Give up"
        )
        .padding(.top, pct(30/852, of: .height))
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

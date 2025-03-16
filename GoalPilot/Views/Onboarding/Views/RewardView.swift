//
//  RewardView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 05/04/2024.
//

import SwiftUI

struct RewardView: View {
    @Environment(OnboardingViewModel.self) private var onboardingModel
    
    @State private var opacity = 0.0
    
    var body: some View {
        QuestionViewLayout(
            title: ("Amazing!", .init(font: .largeTitle, color: .black)),
            customSection: { customSection },
            spacing: .init(top: 0, aboveTitle: pct(30/852, of: .height), aboveCustomSection: pct(308/852, of: .height))
        )
        .opacity(opacity)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation(onboardingModel.pushEdge == .trailing ? .easeInOut(duration: 0.8).delay(1.5) : nil) {
                opacity = 1
            }
        }
        .onboardingBottomBarSetter {
            onboardingModel.nextButton = .init(title: "Next")
        }
    }
    
    private var customSection: some View {
        Text("Now you perfectly know what your ultimate goal is, what to aim for to achieve it, how you’d like to achieve those things and how you need to do that! \n\n\n\nMost people don't even get to this point!")
            .foregroundStyle(Color.white)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }
}

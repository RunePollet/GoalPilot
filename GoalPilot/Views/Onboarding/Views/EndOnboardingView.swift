//
//  EndOnboardingView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 05/04/2024.
//

import SwiftUI

struct EndOnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(GlobalViewModel.self) private var globalModel
    @Environment(OnboardingViewModel.self) private var onboardingModel
    @Environment(Goal.self) private var goal
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .limitFrame(maxHeight: pct(270/852, of: .height))
            
            Text("Let’s create your first \nweekly planning")
                .foregroundStyle(.black)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .onboardingBottomBarSetter {
            onboardingModel.nextButton = .init(title: "Let's go!", action: .completionOnly, completion: {
                if goal.isConfigured {
                    onboardingModel.dismissOnboarding {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            globalModel.showFirstPlanningCreationSheet(includeAlert: true)
                        }
                    }
                }
                else {
                    WindowService.window()?.presentAlert(.goalNotConfigured)
                }
            })
            onboardingModel.secondaryButton = .init(title: "Do later", action: .dismiss)
        }
    }
}

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
        .onboardingBottomBar(
            nextButton: nil,
            primaryButton: .init(title: "Let's go!", action: {
                dismiss {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        globalModel.showFirstPlanningCreationSheet(includeAlert: true)
                    }
                }
            }),
            secondaryButton: .init(title: "Do later", action: { dismiss() })
        )
    }
    
    func dismiss(completion: (() -> Void)? = nil) {
        modelContext.saveChanges()
        if goal.isConfigured {
            onboardingModel.dismissOnboarding(completion: completion)
        }
        else {
            WindowService.window()?.presentAlert(.goalNotConfigured)
        }
    }
}

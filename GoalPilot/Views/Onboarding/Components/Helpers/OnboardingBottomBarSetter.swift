//
//  OnboardingBottomBarSetter.swift
//  GoalPilot
//
//  Created by Rune Pollet on 24/09/2024.
//

import SwiftUI

struct OnboardingBottomBarSetter: ViewModifier {
    @Environment(OnboardingViewModel.self) private var onboardingModel
    
    var setter: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onScenePhaseChange(to: .active) {
                setter()
            }
            .onAppear {
                onboardingModel.bottomBarSetter = setter
                onboardingModel.updateBottomBar()
            }
    }
}

extension View {
    /// Sets the given function as the bottom bar setter of the onboarding sequence when this view appears.
    func onboardingBottomBarSetter(setter: @escaping () -> Void) -> some View {
        modifier(
            OnboardingBottomBarSetter(setter: setter)
        )
    }
}

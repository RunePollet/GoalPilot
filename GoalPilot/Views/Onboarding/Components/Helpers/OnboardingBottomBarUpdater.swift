//
//  OnboardingBottomBarUpdater.swift
//  GoalPilot
//
//  Created by Rune Pollet on 24/09/2024.
//

import SwiftUI

struct OnboardingBottomBarUpdater: ViewModifier {
    @Environment(OnboardingViewModel.self) private var onboardingModel
    
    var backButton: OnboardingViewModel.BackButton?
    var nextButton: OnboardingViewModel.NextButton?
    var primaryButton: OnboardingViewModel.BottomBarButton?
    var secondaryButton: OnboardingViewModel.BottomBarButton?
    var infoButton: (() -> Void)?
    var delay: TimeInterval
    
    private var shouldAnimate: Bool { onboardingModel.toolbars[onboardingModel.currentView] == nil }
    
    func body(content: Content) -> some View {
        content
            .onScenePhaseChange(to: .active) {
                update()
            }
            .onAppear {
                withAnimation(shouldAnimate ? .easeInOut.delay(delay) : nil) {
                    update()
                }
            }
    }
    
    func update() {
        onboardingModel.toolbars[onboardingModel.currentView] = .init(backButton: backButton, nextButton: nextButton, primaryButton: primaryButton, secondaryButton: secondaryButton, infoButton: infoButton)
    }
}

extension View {
    /// Sets the given function as the bottom bar setter of the onboarding sequence when this view appears.
    func onboardingBottomBar(backButton: OnboardingViewModel.BackButton? = .init(),
                             nextButton: OnboardingViewModel.NextButton? = .init(),
                             primaryButton: OnboardingViewModel.BottomBarButton? = nil,
                             secondaryButton: OnboardingViewModel.BottomBarButton? = nil,
                             infoButton: (() -> Void)? = nil,
                             delay: TimeInterval = .zero) -> some View {
        modifier(
            OnboardingBottomBarUpdater(backButton: backButton, nextButton: nextButton, primaryButton: primaryButton, secondaryButton: secondaryButton, infoButton: infoButton, delay: delay)
        )
    }
}

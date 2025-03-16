//
//  AppView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 25/03/2024.
//

import SwiftUI

struct AppView: View {
    @Environment(OnboardingViewModel.self) private var onboardingModel
    
    var body: some View {
        if onboardingModel.isOnboarding {
            OnboardingSequenceView()
                .preferredColorScheme(.light)
                .transition(.move(edge: .top))
        }
        else {
            MainTabView()
        }
    }
}

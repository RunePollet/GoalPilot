//
//  IntroView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 04/04/2024.
//

import SwiftUI

struct IntroView: View {
    @Environment(OnboardingViewModel.self) private var onboardingModel
    @Environment(GlobalViewModel.self) private var globalModel
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 10) {
                Text("Hi \(TextService.shared.username)!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Welcome to")
            }
            .padding(.top, pct(50/852, of: .height))
            
            Text("GoalPilot")
                .font(.system(size: 48, weight: .bold))
                .padding(.top, pct(119/852, of: .height))
            
            Text("We will help you achieve your ultimate goal\nin life or find out what it is!")
                .multilineTextAlignment(.center)
                .padding(.top, pct(119/852, of: .height))
            
            Spacer()
        }
        .foregroundStyle(Color.white)
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.horizontal)
        .onboardingBottomBarSetter {
            onboardingModel.nextButton = .init(title: "Let's Go!")
        }
    }
}

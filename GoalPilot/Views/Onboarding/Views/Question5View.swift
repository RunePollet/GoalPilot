//
//  Question5View.swift
//  GoalPilot
//
//  Created by Rune Pollet on 05/04/2024.
//

import SwiftUI

struct Question5View: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(Goal.self) private var goal
    @Environment(OnboardingViewModel.self) private var onboardingModel
    @Environment(GlobalViewModel.self) private var globalModel
    
    @FocusState private var isFocused
    @State private var showSheet = false
    
    var body: some View {
        QuestionViewLayout(
            preText: ("Alright, now we know what to aim for to \nachieve your goal!", .init()),
            title: ("In what way would you prefer to obtain this?", .init()),
            tip: ("Think outside the box, it doesn't have to be a \nparticular job, it just has to be something you like.", .init()),
            customSection: { customSection }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .dismissKeyboardArea {
            goal.chosenWay = goal.chosenWay.trimmingCharacters(in: .whitespacesAndNewlines)
            isFocused = false
        }
        .onboardingBottomBar(
            backButton: .init(dismissKeyboard: { isFocused = false }),
            nextButton: .init(isDisabled: { !goal.hasChosenWay }, dismissKeyboard: { isFocused = false }),
            infoButton: {
                showSheet = true
            }
        )
        .sheet(isPresented: $showSheet) {
            sheet
        }
    }
    
    private var customSection: some View {
        @Bindable var goal = goal
        
        return TextField("Describe your way", text: $goal.chosenWay, axis: .vertical)
            .focused($isFocused)
            .textFieldStyle(OnboardingTextFieldStyle(input: $goal.chosenWay, focused: isFocused))
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal)
    }
    
    private var sheet: some View {
        NavigationStack {
            SheetViewLayout(mode: .example, title: "In what way would you\nprefer to obtain this?") {
                // Custom Section
                ExampleRow(text: "I’d like to earn money doing photography. Travel the world whilst capturing beautiful moments and landscapes. Earning money by selling my photos, funding and social media.")
                    .padding(.horizontal)
            }
        }
    }
}

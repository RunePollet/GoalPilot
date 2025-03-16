//
//  Question4View.swift
//  GoalPilot
//
//  Created by Rune Pollet on 05/04/2024.
//

import SwiftUI
import SwiftData

struct Question4View: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(OnboardingViewModel.self) private var onboardingModel
    @Environment(Goal.self) private var goal
    
    @State private var inputTitle = ""
    @State private var inputInfo: String?
    
    @Query(Requirement.descriptor(), animation: .smooth) private var requirements: [Requirement]
    @FocusState private var focusedField: DualTextField.Field?
    
    var body: some View {
        QuestionViewLayout(
            preText: ("You’re making great progress! \nLet’s get more to the practical side.", .init()),
            title: ("What is required to achieve this?", .init()),
            tip: ("Try to pin point just a few things you certainly \nneed to achieve your pillars.", .init()),
            customSection: { customSection }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .dismissKeyboardArea {
            focusedField = nil
        }
        .onboardingBottomBarSetter {
            onboardingModel.nextButton = .init(isDisabled: { !requirements.allSatisfy({ $0.isConfigured }) || requirements.isEmpty })
        }
    }
    
    private var customSection: some View {
        let inputView = InputView(
            firstInput: $inputTitle, firstPrompt: "Requirement",
            secondInput: $inputInfo.boundString,
            focusedField: $focusedField,
            addCompletion: {
                // Add Requirement
                let newRequirement = Requirement()
                newRequirement.title = inputTitle
                newRequirement.info = inputInfo
                newRequirement.insert(into: modelContext)
                
                // Establish parent relationship
                newRequirement.parent = goal
                
                // Clean the text fields
                inputTitle = ""
                inputInfo = ""
                
                // Focus on the title text field
                if focusedField == .second { focusedField = .first }
            }
        )
        
        return ListView(focusedField: focusedField, inputView: { inputView }, listContent: requirements) { requirement in
            ItemRow(title: requirement.title, info: requirement.info, removeCompletion: {
                requirement.delete(from: modelContext)
            })
            .background(MaterialBackground())
        }
        .padding(.horizontal)
    }
}

// Elements for the sheet
extension Question4View {
    static var sheetView: some View {
        SheetViewLayout(mode: .example, title: "What is required to achieve this?") {
            // Custom Section
            VStack(spacing: 10) {
                ExampleUnfoldedRow(title: "Money", info: "I’ll need to earn enough money to be able to afford all my pillars and never worry about money.")
                
                ExampleUnfoldedRow(title: "Smart investments", info: "Through enough smart investments I’ll be able to earn passive income.")
                
                ExampleRow(text: "A loving partner.")
            }
            .padding(.horizontal)
        }
    }
}

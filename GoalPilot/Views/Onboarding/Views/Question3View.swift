//
//  Question3View.swift
//  GoalPilot
//
//  Created by Rune Pollet on 05/04/2024.
//

import SwiftUI
import SwiftData

struct Question3View: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(OnboardingViewModel.self) private var onboardingModel
    @Environment(Goal.self) private var goal
    
    @State private var inputTitle = ""
    @State private var inputInfo: String?
    
    @Query(filter: #Predicate<Pillar> { !$0.isDeleted }, sort: \Pillar.creationDate, animation: .smooth) private var pillars: [Pillar]
    @FocusState private var focusedField: DualTextField.Field?
    @State private var showSheet = false
    
    var body: some View {
        QuestionViewLayout(
            preText: ("What a great goal to reach for!\nNow, to really pin down your ultimate goal", .init()),
            title: ("On what pillars does your goal rest?", .init()),
            tip: ("These could be actual things or experiences.", .init()),
            customSection: { customSection }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .dismissKeyboardArea {
            focusedField = nil
        }
        .onboardingBottomBar(
            backButton: .init(dismissKeyboard: { focusedField = nil }),
            nextButton: .init(isDisabled: { !pillars.allSatisfy({ $0.isConfigured }) || pillars.isEmpty }, dismissKeyboard: { focusedField = nil }),
            infoButton: {
                showSheet = true
            }
        )
        .sheet(isPresented: $showSheet) {
            sheet
        }
    }
    
    private var customSection: some View {
        let inputView = InputView(
            firstInput: $inputTitle, firstPrompt: "Pillar",
            secondInput: $inputInfo.boundString,
            focusedField: $focusedField,
            addCompletion: {
                // Add Pillar
                let newPillar = Pillar()
                newPillar.title = inputTitle
                newPillar.info = inputInfo
                newPillar.insert(into: modelContext)
                
                // Establish parent relationship
                newPillar.establishRelationship(for: \.parent, with: goal, within: modelContext)
                
                // Clean the text fields
                inputTitle = ""
                inputInfo = ""
                
                // Focus on the title text field
                if focusedField == .second { focusedField = .first }
            }
        )
        
        return ListView(focusedField: focusedField, inputView: { inputView }, listContent: pillars) { pillar in
            ItemRow(title: pillar.title, info: pillar.info, removeCompletion: {
                pillar.delete(from: modelContext)
            })
            .background(MaterialBackground())
        }
        .padding(.horizontal)
    }
    
    private var sheet: some View {
        NavigationStack {
            SheetViewLayout(mode: .example, title: "On what pillars does your goal rest?") {
                // Custom Section
                VStack(spacing: 10) {
                    ExampleRow(text: "Earn money passively")
                    
                    ExampleRow(text: "Have a partner and start a family")
                    
                    ExampleUnfoldedRow(title: "Own my dream mansion", info: "I would like it to be in a quiet place, like the countryside.")
                    
                    ExampleUnfoldedRow(title: "Own my dream cars", info: "I’d like to own a Porsche 911 and an Aston Martin DBX.")
                    
                    ExampleRow(text: "Own a vacationhouse in the south of France")
                }
                .padding(.horizontal)
            }
        }
    }
}

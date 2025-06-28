//
//  Question6View.swift
//  GoalPilot
//
//  Created by Rune Pollet on 05/04/2024.
//

import SwiftUI
import SwiftData

struct Question6View: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(OnboardingViewModel.self) private var onboardingModel
    @Environment(Goal.self) private var goal
    
    @State private var inputTitle = ""
    @State private var inputInfo: String? = ""
    
    // View coordination
    @FocusState private var focusedField: DualTextField.Field?
    @State private var showSheet = false
    @State private var dragItem: Milestone? = nil
    @State private var refInputHeight: CGFloat = 0
    @State private var curInputHeight: CGFloat = 0
    @State private var animateListOffset = false
    
    // Accessibility
    @Query(Pillar.descriptor()) private var pillars: [Pillar]
    @Query(Milestone.descriptor()) private var persistedMilestones: [Milestone]
    @State private var milestones = [Milestone]()
    
    var body: some View {
        QuestionViewLayout(
            preText: ("Perfect! Now take your time answering\nthe next question.", .init(color: .black)),
            title: ("What milestones do you need to achieve first?", .init()),
            customSection: { milestoneList },
            spacing: .init(top: pct(30/852, of: .height), aboveTitle: pct(80/852, of: .height), aboveCustomSection: pct(60/852, of: .height))
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .dismissKeyboardArea { focusedField = nil }
        .onboardingBottomBar(
            nextButton: .init(isDisabled: { !persistedMilestones.filter { !$0.isConfigured }.isEmpty || persistedMilestones.isEmpty }),
            infoButton: {
                showSheet = true
            }
        )
        .sheet(isPresented: $showSheet) {
            sheet
        }
        .onAppear {
            milestones = persistedMilestones
        }
    }
    
    private var milestoneList: some View {
        let inputView = InputView(
            firstInput: $inputTitle, firstPrompt: "Milestone",
            secondInput: $inputInfo.boundString,
            focusedField: $focusedField,
            addCompletion: {
                // Add Milestone
                let newMilestone = Milestone()
                newMilestone.title = inputTitle
                newMilestone.info = inputInfo
                newMilestone.insert(into: modelContext)
                
                // Establish parent relationship
                newMilestone.establishRelationship(for: \.parent, with: goal, within: modelContext)
                
                withAnimation(.smooth) {
                    milestones.insert(newMilestone, at: 0)
                }
                
                // Clean the text fields
                inputTitle = ""
                inputInfo = ""
                
                // Focus on the title text field
                if focusedField == .second { focusedField = .first }
            }
        ).padding(.horizontal)
        
        return ListView(focusedField: focusedField, inputView: { inputView }, listContent: milestones) { milestone in
            let i = milestones.firstIndex(of: milestone)
            @Bindable var milestone = milestone
            
            return Group {
                if let i {
                    MilestoneItemRow(milestone: milestone, dragItem: $dragItem, remove: {
                        withAnimation(.bouncy) {
                            _ = milestones.remove(at: i)
                        }
                        milestone.delete(from: modelContext)
                    })
                    .rearrange(milestone: milestone, milestones: $milestones, dragItem: $dragItem)
                }
            }
        }
        .rearrangeable()
        .scrollDisabled(dragItem != nil)
    }
    
    private var sheet: some View {
        NavigationStack {
            SheetViewLayout(mode: .example, title: "What milestones do you need\nto achieve first?", titlePadding: 20/852) {
                // Custom Section
                ScrollView {
                    ExampleUnfoldedMilestoneRow(orderIndex: 7, title: "Being successful with my photos", info: "So I can sell them to also earn money, getting sponsored, ... and start investing.", attributes: ["Earn money passively.", "Own my dream mansion.", "Own my dream cars.", "Own a vacationhouse in the south of France."], noneSelectedTitle: nil)
                    
                    ExampleUnfoldedMilestoneRow(orderIndex: 6, title: "Having grown on social media", info: "Attaining a good reputation and earning some money with it, mostly on social media.", attributes: ["Earn money passively.", "Own my dream mansion.", "Own my dream cars.", "Own a vacationhouse in the south of France."], noneSelectedTitle: nil)
                    
                    ExampleUnfoldedMilestoneRow(orderIndex: 5, title: "Being different.", info: "If I figure out how I can stand, I’ll have a better chance to succeed and I’ll have a reason as to why people would like my photos. This can also be good for any marketing.", attributes: ["Earn money passively."], noneSelectedTitle: nil)
                    
                    ExampleUnfoldedMilestoneRow(orderIndex: 4, title: "Knowing social media", info: "If I study the playing field first, I’ll know what I’ll be doing and have a big advantage.", attributes: ["Earn money passively."], noneSelectedTitle: nil)
                    
                    ExampleMilestoneRow(orderIndex: 3, text: "Get social media accounts and start posting.")
                    
                    ExampleUnfoldedMilestoneRow(orderIndex: 2, title: "Having the skill", info: "Before I can start trying to make money with photography, I need to learn it and get good at it.", attributes: nil, noneSelectedTitle: nil)
                    
                    ExampleMilestoneRow(orderIndex: 1, text: "Get a camera and editing software.")
                        .padding(.bottom)
                }
                .scrollIndicators(.hidden)
                .padding(.horizontal)
            }
        }
    }
}

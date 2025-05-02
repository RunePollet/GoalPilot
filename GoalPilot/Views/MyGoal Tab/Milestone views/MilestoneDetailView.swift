//
//  MilestoneDetailView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 14/06/2024.
//

import SwiftUI
import SwiftData

/// Shows details about a milestone and lets the user edit them.
struct MilestoneDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(Goal.self) private var goal
    @Environment(GlobalViewModel.self) private var globalModel
    @Environment(PlannerViewModel.self) private var plannerModel
    @Environment(StreakViewModel.self) private var streakModel
    @Environment(NavigationViewModel.self) private var navigationModel
    @Environment(MAAnimationHandler.self) private var animationHandler
    
    enum Row {
        case title, info, planning
    }
    
    @Bindable var milestone: Milestone
    
    // View coordination
    @State private var showUnachieveDialog = false
    @State private var showPreviousNotAchievedAlert = false
    @State private var highlightDoneButton: Bool
    
    @State private var initiatedEditing = false
    private var hideBackButton: Bool {
        initiatedEditing && navigationModel.isEditing
    }
    
    // Accessibility
    @Query(Milestone.descriptor()) private var allMilestones: [Milestone]
    
    init(milestone: Milestone) {
        self.milestone = milestone
        self.highlightDoneButton = milestone.achieved
    }
    
    var body: some View {
        MilestoneForm(milestone: milestone, isEditing: navigationModel.isEditing, isCreating: navigationModel.isCreating) {
            // Deletion
            milestone.delete(from: modelContext)
            if initiatedEditing {
                navigationModel.isEditing = false
            }
            dismiss()
        }
        .navigationTitle(milestone.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(hideBackButton)
        .toolbar { toolbar }
        .confirmationDialog("", isPresented: $showUnachieveDialog) {
            Button("Unachieve") {
                // Set the achieved property and the button
                milestone.achieved = false
                withAnimation {
                    highlightDoneButton = false
                }
                
                // Update the current planning
                if let planning = milestone.planning {
                    plannerModel.setCurrentPlanning(to: planning, using: modelContext)
                    streakModel.resetWeek()
                }
                
                // Set the goal to be not achieved if needed
                if goal.achieved {
                    goal.setAchieved(false, currentPlanning: plannerModel.currentPlanning)
                }
            }
        }
        .sensoryFeedback(.impact, trigger: highlightDoneButton)
        .alert("Previous milestones not achieved", isPresented: $showPreviousNotAchievedAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Continue") {
                setAchieved()
            }
        } message: {
            Text("You haven't achieved your previous milestones yet, do you stil want to continue?")
        }
        .onChange(of: navigationModel.isEditing) { oldValue, newValue in
            if !newValue && initiatedEditing {
                initiatedEditing = false
            }
        }
    }
    
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        @Bindable var navigationModel = navigationModel
        
        // Edit button
        EditToolbarItems(isEditing: navigationModel.isEditing, showEditButton: !navigationModel.hideEditButton, editAction: {
            withAnimation(.smooth) {
                navigationModel.isEditing.toggle()
            }
            initiatedEditing = navigationModel.isEditing
        })
        
        // Set achieved button
        ToolbarItem(placement: .status) {
            Button {
                if !milestone.achieved {
                    let previousMilestones = allMilestones.filter { $0.orderIndex < milestone.orderIndex }
                    if previousMilestones.allSatisfy(\.achieved) {
                        setAchieved()
                    } else {
                        showPreviousNotAchievedAlert = true
                    }
                } else {
                    showUnachieveDialog = true
                }
            } label: {
                Image(systemName: highlightDoneButton ? "checkmark.square.fill" : "square")
                    .foregroundStyle(highlightDoneButton ? Color.accentColor : Color.secondary)
                    .contentTransition(.symbolEffect(.replace))
            }
        }
    }
    
    func setAchieved() {
        // Highlight the button
        withAnimation {
            highlightDoneButton = true
        }
        
        // Show the milestone achieved animation
        animationHandler.runAnimation(for: milestone, milestones: allMilestones.reversed(), focusedMilestone: plannerModel.currentPlanning?.parent, globalModel: globalModel, completion: {
            // Set the achieved property
            milestone.achieved = true
            
            // Update the current planning
            if let index = allMilestones.firstIndex(of: milestone), index-1 >= 0, let nextPlanning = allMilestones[index-1].planning {
                plannerModel.setCurrentPlanning(to: nextPlanning, using: modelContext)
                streakModel.resetWeek()
            }
        }, allMilestonesAchievedCompletion: {
            // Set the achieved status of the goal
            goal.setAchieved(true, currentPlanning: plannerModel.currentPlanning)
        })
    }
}

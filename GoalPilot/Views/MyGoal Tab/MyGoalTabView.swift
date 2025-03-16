//
//  MyGoalTabView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 01/06/2024.
//

import SwiftUI
import SwiftData

/// The main view for the MyGoal tab.
struct MyGoalTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @Environment(Goal.self) private var goal
    @Environment(OnboardingViewModel.self) private var onboardingModel
    @Environment(GlobalViewModel.self) private var globalModel
    @Environment(PlannerViewModel.self) private var plannerModel
    @Environment(StreakViewModel.self) private var streakModel
    
    private enum Content {
        case goal
        case milestones
    }
    
    // Accessibility
    @Query(Milestone.descriptor()) private var milestones: [Milestone]
    
    // Navigation
    @State private var navigationModel = NavigationViewModel()
    @State private var currentContent: Self.Content = .goal
    @State private var createPlanningForMilestone: Milestone?
    @State private var createMilestone = false
    
    var body: some View {
        NavigationStack(path: $navigationModel.path) {
            VStack {
                if goal.achieved {
                    newGoalButton
                        .plain()
                }
                
                if currentContent == .goal {
                    GoalSummary()
                        .transition(.move(edge: .leading))
                }
                else {
                    milestoneList
                        .transition(.move(edge: .trailing))
                }
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .toolbarVisibility(navigationModel.hideTabBar ? .hidden : .visible, for: .tabBar)
            .animation(.default, value: navigationModel.hideTabBar)
            .navigationTitle("My Goal")
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    viewSwitcher
                    
                    NavigationLink(value: SettingsDestination()) {
                        Image(systemName: "gear")
                    }
                }
            }
            .navigationDestination(for: TextPropertyEditor<Goal>.Model.self) { model in
                TextPropertyEditor(model: model)
            }
            .navigationDestination(for: SettingsDestination.self) { _ in
                SettingsView()
            }
        }
        .environment(navigationModel)
        .sheet(item: $createPlanningForMilestone) { milestone in
            NavigationModelStack(isCreating: true) {
                CreatePlanningView(parent: milestone)
            }
        }
        .sheet(isPresented: $createMilestone) {
            NavigationModelStack(isCreating: true) {
                CreateMilestoneView()
            }
        }
        .onChange(of: globalModel.resetUITrigger) { oldValue, newValue in
            navigationModel.path = .init()
        }
        .onAppear { navigationModel.isEditing = false }
    }
    
    private var newGoalButton: some View {
        Button {
            WindowService.window()?.presentAlert(.deleteGoal {
                goal.delete(from: modelContext, onboardingModel: onboardingModel, globalModel: globalModel, plannerModel: plannerModel, streakModel: streakModel)
            })
        } label: {
            Text("New goal")
                .fontWeight(.bold)
                .foregroundStyle(.background)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .padding([.horizontal, .top])
        .tileShadow()
    }
    
    private var viewSwitcher: some View {
        Button {
            withAnimation(.smooth) {
                switch currentContent {
                case .goal:
                    currentContent = .milestones
                case .milestones:
                    currentContent = .goal
                }
            }
        } label: {
            Image(systemName: "arrow.left.arrow.right")
                .imageScale(.large)
        }
    }
    
    private var milestoneList: some View {
        Group {
            if !milestones.isEmpty {
                MilestoneAndPlanningList(milestones: Milestone.getAll(from: modelContext), selectPlanningOfMilestone: { milestone in
                    if milestone.planning == nil {
                        createPlanningForMilestone = milestone
                    }
                })
            } else {
                ContentMissingView(icon: "sparkle.magnifyingglass", title: "Missing milestones", info: "Please create a milestone to view it here.") {
                    Button("Create milestone") {
                        createMilestone = true
                    }
                }
            }
        }
    }
}

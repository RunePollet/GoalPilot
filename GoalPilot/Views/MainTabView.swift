//
//  MainTabView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 01/06/2024.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(GlobalViewModel.self) private var globalModel
    @Environment(StreakViewModel.self) private var streakModel
    
    enum Tab: Equatable {
        case journey
        case planner
        case goal
    }
    
    // View Coordination
    @State private var currentTab: Self.Tab = .journey
    @State private var showFeedbackAlert = false
    
    @AppStorage("LAUNCH_TIMES_THIS_WEEK") private var launchTimesThisWeek = 0
    @AppStorage("LAST_LAUNCH") private var lastLaunch: Date?
    @AppStorage("ASKED_FEEDBACK") private var askedFeedback = false
    
    // Accessibility
    @Query(Milestone.descriptor()) private var milestones: [Milestone]
    private var maAnimationHandler = MAAnimationHandler()
    
    var body: some View {
        TabView(selection: $currentTab) {
            Group {
                JourneyTabView()
                    .onPreferenceChange(StreakCounterBounds.self) { values in
                        if let value = values[JourneyTabView.streakCounterBoundsKey] {
                            DispatchQueue.main.async {
                                streakModel.animationTargetAnchor = value
                            }
                        }
                    }
                    .onPreferenceChange(Landscape.StarIndicatorBounds.self) { values in
                        DispatchQueue.main.async {
                            maAnimationHandler.slideTarget = values[Landscape.LandscapeView.goalStarID]
                        }
                    }
                    .tabItem {
                        tabItemLabel(imageName: "location.north.line", description: "Journey", tag: .journey)
                    }
                    .tag(Tab.journey)
                
                PlannerTabView()
                    .tabItem {
                        tabItemLabel(imageName: "list.bullet.rectangle.portrait", description: "Planner", tag: .planner)
                    }
                    .tag(Tab.planner)
                
                MyGoalTabView()
                    .tabItem {
                        tabItemLabel(imageName: "star.circle", description: "My Goal", tag: .goal)
                    }
                    .tag(Tab.goal)
            }
            .toolbarBackground(.ultraThinMaterial, for: .tabBar)
            .toolbarBackground(currentTab == .journey ? .hidden : .visible, for: .tabBar)
        }
        .environment(maAnimationHandler)
        .overlayPreferenceValue(Landscape.StarIndicatorBounds.self) { values in
            if maAnimationHandler.isAnimating {
                MAAnimationView(handler: maAnimationHandler)
            }
        }
        .overlay {
            GMStarPowerup()
        }
        .sheet(isPresented: .init(get: { globalModel.showFirstPlanningCreationSheet }, set: { globalModel.showFirstPlanningCreationSheet = $0 })) {
            let firstMilestone = Milestone.getAll(from: modelContext).first { $0.orderIndex == 1 }
            if let firstMilestone {
                createPlanning(for: firstMilestone)
            }
        }
        .alert("What do you think?", isPresented: $showFeedbackAlert, actions: {
            Link("Share your thoughts", destination: URL(string: "https://goalpilot.be/feedback/")!)
            
            Button("No thanks") {}
        }, message: {
            Text(
                """
                👋 Hi, I'm Rune, the creator of GoalPilot. And I aim to make this an invaluable app for everyone!
                So, what do you think of it? 
                Share anything you want!🤝
                """
            )
        })
        .onChange(of: globalModel.resetUITrigger) {
            self.currentTab = .journey
        }
        .onAppear {
            // Count the amount of launch times this week
            if let lastLaunch, Date.newWeek(since: lastLaunch) {
                launchTimesThisWeek = 0
            }
            launchTimesThisWeek += 1
            
            // Show the feedback alert
            if launchTimesThisWeek == 4 && !askedFeedback {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showFeedbackAlert = true
                    askedFeedback = true
                }
            }
        }
    }
    
    private func tabItemLabel(imageName: String, description: String, tag: Self.Tab) -> some View {
        VStack {
            Image(systemName: imageName)
            Text(description)
                .font(.footnote)
        }
    }
    
    private func createPlanning(for milestone: Milestone) -> some View {
        @Bindable var globalModel = globalModel
        
        return NavigationModelStack(isCreating: true) {
            CreatePlanningView(parent: milestone)
        }
        .alert("Creating a planning", isPresented: $globalModel.includeAlert) {
            Button("Ok") {}
        } message: {
            Text("Let's create a weekly planning to achieve your first milestone. First, give it a name and a description if you want, then you can add the activities you want to do to achieve your first milestone.")
        }
    }
}

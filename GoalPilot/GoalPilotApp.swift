//
//  GoalPilotApp.swift
//  GoalPilot
//
//  Created by Rune Pollet on 25/03/2024.
//
//  GoalPilot aims to guide its users on their mental journey to their goal. It features:
//
//  - An interactive and comprehensive onboarding:
//      GoalPilot has an interactive onboarding sequence with comprehensive content to help the user discover and define their dream.
//      It organizes this into a main goal, its pillars, the requirements associated with the goal, and milestones, each with their own plannings
//      to achieve them. All of these have their own data models, which are stored and managed using SwiftData.
//
//  - A planner:
//      Within the app, the user has a planner at their disposal that works on a weekly basis and can send motivational notifications. It aims to keep
//      the user on track of their progress and provides features like reminders and recurring notes for extended capabilities.
//
//  - A visual representation of the path to their goal:
//      The home view features a playful and friendly illustration of the path to their goal which is animated when great progress is made.
//      The illustration also adapts to the time of day and has a summarized list of the path which shows a detail of the current planning
//      to provide a clear overview.
//
//  - A weekly streak counter:
//      The home view also features a streak counter which counts the number of consecutive weeks the user has worked for their dream. This
//      gamification aims to motivate the user to keep going and take pride in how far they have come.
//
//  - Interactive and rewarding animations:
//      These include an interactive animation to increase the weekly streak, the onboarding’s animations and accompanying animations for events like
//      milestone achievement and the final achievement of the user’s goal.
//
//  - Goal overview and settings:
//      The app shows all data about the user’s goal in an overview. It allows the user to reread the description of their goal and path as well as
//      editing them. General settings also enable control over notifications and the username.
//
//  - Mental support:
//      GoalPilot also tries to keep the user’s spark for their dream alive. Providing elaborative content in a smooth
//      design to support the user when they want to give up. And a standby mode to take a brake from it all. Nonetheless, the user always has the
//      option to continue with this intention.
//
//  With these features, GoalPilot hopes to ignite a fire in the user, a never-ending source of abundant energy and enthusiasm to live their life to
//  the fullest and on their own terms.
//

import SwiftUI
import SwiftData

@main
struct GoalPilotApp: App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let modelContainer: ModelContainer
    @State var goal: Goal
    let globalModel = GlobalViewModel()
    let onboardingModel = OnboardingViewModel()
    let plannerModel: PlannerViewModel
    let streakModel: StreakViewModel

    init() {
        // Set styling settings for the app
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(named: AssetsCatalog.complementaryColorID)
        UIView.appearance().tintColor = UIColor(named: AssetsCatalog.accentColorID)
        
        // Set the model container and fetch the goal
        self.modelContainer = try! ModelContainer(for: Goal.self, Pillar.self, Requirement.self, Milestone.self, Planning.self, Activity.self, RecurringNote.self, Reminder.self, configurations: .init())
        self.goal = Goal.get(from: modelContainer.mainContext)
        self.plannerModel = PlannerViewModel(modelContainer.mainContext)
        self.streakModel = StreakViewModel(globalModel: globalModel)
    }
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .onScenePhaseChange(to: .background) {
                    // Do any saving or clean-up
                    onboardingModel.save()
                    plannerModel.save()
                    streakModel.save()
                    TextService.shared.save()
                }
                .onChange(of: goal.isDeleted) { oldValue, newValue in
                    // Re-initialize the goal if it is deleted
                    if newValue {
                        goal = Goal.get(from: modelContainer.mainContext)
                    }
                }
        }
        .environment(globalModel)
        .environment(onboardingModel)
        .environment(plannerModel)
        .environment(streakModel)
        .environment(goal)
        .modelContainer(modelContainer)
    }
}

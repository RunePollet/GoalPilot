//
//  JourneyTabView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 01/06/2024.
//

import SwiftUI
import SwiftData

/// The main view for the Journey tab.
struct JourneyTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Goal.self) private var goal
    @Environment(GlobalViewModel.self) private var globalModel
    @Environment(StreakViewModel.self) private var streakModel
    @Environment(PlannerViewModel.self) private var plannerModel
    @Environment(TimeOfDayViewModel.self) private var timeOfDayModel
    
    // Navigation
    @State private var navigationModel = NavigationViewModel()
    @State private var createPlanningForMilestone: Milestone?
    
    // Accessibility
    @Query(Milestone.descriptor()) private var milestones: [Milestone]
    private var currentPlanning: Planning? {
        plannerModel.currentPlanning
    }
    private var nextToAchieve: Milestone? {
        milestones.last { !$0.achieved }
    }
    
    // View coordination
    nonisolated static let streakCounterBoundsKey = "STREAK_COUNTER_BOUNDS"
    @State private var scrollPosition: UUID?
    private var landscapeStars: [Landscape.LandscapeView.StarConfiguration] {
        Landscape.LandscapeView.getLandscapeStars(nextStarToReach: nextToAchieve?.asStarConfiguration, totalStars: milestones.reversed().map(\.asStarConfiguration))
    }
    
    var body: some View {
        NavigationStack(path: $navigationModel.path) {
            VStack(spacing: 0) {
                // Landscape and title bar
                VStack(spacing: 0) {
                    titleBar
                    
                    Landscape.LandscapeView(stars: landscapeStars, focusedStar: currentPlanning?.parent?.asStarConfiguration, goalStarGlow: goal.achieved)
                        .frame(height: pct(292/393, of: .width))
                }
                .fixedSize(horizontal: false, vertical: true)
                .background {
                    Landscape.SkyGradient(timeOfDay: timeOfDayModel.currentTimeOfDay, stop: 0.2)
                        .ignoresSafeArea()
                }
                
                pathList
            }
            .toolbarVisibility(navigationModel.hideTabBar ? .hidden : .visible, for: .tabBar)
            .animation(.default, value: navigationModel.hideTabBar)
            .sensoryFeedback(.impact(weight: .heavy), trigger: goal.achieved) { oldValue, newValue in
                return newValue
            }
            .overlay(alignment: .bottom) {
                Landscape.TabBarBackgroundHill()
                    .ignoresSafeArea()
            }
            .overlay(alignment: .top) {
                Group {
                    if let url = URL(string: "https://weatherkit.apple.com/legal-attribution.html") {
                        Link("Weather", destination: url)
                    } else {
                        Text("Weather")
                    }
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
            .navigationDestination(for: SelectedPlanning.self) { selection in
                if selection.isCurrent {
                    PlannerDayView(plannerModel: plannerModel)
                        .onAppear {
                            plannerModel.currentDate = .now
                        }
                } else {
                    PlanningDetailView(planning: selection.planning)
                }
            }
            .sheet(item: $createPlanningForMilestone) { milestone in
                NavigationModelStack(isCreating: true) {
                    CreatePlanningView(parent: milestone)
                }
            }
            .onAppear {
                navigationModel.isEditing = false
                plannerModel.updateCurrentPlanning(modelContext: modelContext, refreshNotifications: false)
            }
            .task {
                await timeOfDayModel.updateTimeOfDay()
            }
        }
        .environment(navigationModel)
        .onChange(of: globalModel.resetUITrigger) {
            navigationModel.path = .init()
        }
    }
    
    /// A list to summarize the path to the user's goal
    private var pathList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(milestones) { milestone in
                    PathSection(
                        title: milestone.title,
                        starNumber: milestone.orderIndex,
                        phase: milestone.achieved ? .completed : (milestone.planning != nil && milestone.planning == currentPlanning ? .inProgress : .todo)
                    ) {
                        if let planning = milestone.planning {
                            PlanningTile(planning: planning, showDetail: planning == currentPlanning) { activity in
                                if let currentPlanning {
                                    streakModel.enlistAsCompleted(activity: activity, currentPlanning: currentPlanning)
                                }
                            }
                        } else {
                            Button {
                                createPlanningForMilestone = milestone
                            } label: {
                                PathListItem(planning: nil)
                            }
                        }
                    }
                    .id(milestone.id)
                }
            }
            .scrollTargetLayout()
            .padding(.bottom, pct(30/852, of: .height))
        }
        .scrollPosition(id: $scrollPosition, anchor: .center)
        .defaultScrollAnchor(.bottom)
        .padding(.horizontal)
        .background {
            Color(AssetsCatalog.firstHillColorID)
                .ignoresSafeArea()
        }
        .onAppear {
            DispatchQueue.main.async {
                scrollPosition = currentPlanning?.parent?.id
            }
        }
    }
    
    private var titleBar: some View {
        HStack(alignment: .firstTextBaseline) {
            // Title
            Text(TextService.shared.greetingBasedOnTimeOfDay(timeOfDayModel.currentTimeOfDay))
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(2)
            
            Spacer()
            
            // Streak counter
            Menu {
                Text("Finish all activities to increase your weekly streak.")
            } label: {
                HStack {
                    Text("\(streakModel.weeklyStreak)")
                        .contentTransition(.numericText(value: Double(streakModel.weeklyStreak)))
                    Text("🔥")
                        .font(.system(size: 13))
                }
                .lineLimit(1)
                .padding(.vertical, 5)
                .padding(.horizontal)
                .background {
                    Capsule()
                        .foregroundStyle(.thinMaterial)
                }
                .phaseAnimator([1, 1.2, 1], trigger: streakModel.animateStreakCounterTrigger) { content, value in
                    content
                        .scaleEffect(value)
                } animation: { value in
                    Animation.snappy(duration: 0.25)
                }
                .sensoryFeedback(.increase, trigger: streakModel.weeklyStreak) { oldValue, newValue in
                    return oldValue < newValue
                }
            }
            .buttonStyle(.plain)
            .anchorPreference(key: StreakCounterBounds.self, value: .bounds) { anchor in
                return [Self.streakCounterBoundsKey: anchor]
            }
            .onAppear {
                if let currentPlanning = plannerModel.currentPlanning {
                    streakModel.refresh(currentPlanning: currentPlanning)
                }
            }
        }
        .padding([.horizontal, .top])
    }
}

struct StreakCounterBounds: PreferenceKey {
    static let defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String: Anchor<CGRect>], nextValue: () -> [String: Anchor<CGRect>]) {
        for (key, anchor) in nextValue() {
            value[key] = anchor
        }
    }
}

extension JourneyTabView {
    /// An object to use as navigation data when selecting a planning.
    struct SelectedPlanning: Hashable {
        var planning: Planning
        var isCurrent: Bool
    }
}

//
//  GoalSummary.swift
//  GoalPilot
//
//  Created by Rune Pollet on 14/11/2024.
//

import SwiftUI
import SwiftData

/// A summary of the goal and its pillars.
struct GoalSummary: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Goal.self) private var goal
    @Environment(GlobalViewModel.self) private var globalModel
    @Environment(PlannerViewModel.self) private var plannerModel
    @Environment(OnboardingViewModel.self) private var onboardingModel
    @Environment(StreakViewModel.self) private var streakModel
    
    @Query(Pillar.descriptor()) private var pillars: [Pillar]
    @State private var createPillar = false
    
    var body: some View {
        HighlightedList {
            // Goal
            Section {
                NavigationLink(value: GoalDetailDestination()) {
                    Text(goal.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.tappable)
                .rowSeparatorHidden()
                .applyPaddingTo(edges: .top)
            }
            .sectionBackgroundColor(.clear)
            .strokeHidden()
            
            Section("Description") {
                if let info = goal.info {
                    NavigationLink(info, value: GoalDetailDestination()) 
                } else {
                    NavigationLink(value: TextPropertyEditor<Goal>.Model.goalDescription(goal)) {
                        Text("Add description")
                            .drillIn()
                    }
                }
            }
            .buttonStyle(.tappable)
            
            Section("Path Summary") {
                if let pathSummary = goal.pathSummary {
                    NavigationLink(pathSummary, value: GoalDetailDestination())
                } else {
                    NavigationLink(value: TextPropertyEditor<Goal>.Model.pathSummary(goal)) {
                        Text("Add your path summary")
                            .drillIn()
                    }
                }
            }
            .buttonStyle(.tappable)
            
            // Pillars
            Section("Pillars") {
                pillarsGrid
                    .rowSeparatorHidden()
                    .applyPaddingTo(edges: [])
            }
            .sectionBackgroundColor(.clear)
            .strokeHidden()
        }
        .navigationDestination(for: GoalDetailDestination.self) { _ in
            GoalDetailView()
        }
        .navigationDestination(for: NavigationData<Self, Pillar>.self) { navData in
            PillarsDetailView(selected: navData.data)
        }
        .sheet(isPresented: $createPillar) {
            NavigationModelStack(isCreating: true) {
                CreatePillarView()
            }
        }
    }
    
    private var pillarsGrid: some View {
        let spacing = 10.0
        var gridItems: [GridItem] {
            [GridItem(.flexible(), spacing: spacing, alignment: .top),
             GridItem(.flexible(), spacing: spacing, alignment: .top)]
        }
        
        return LazyVGrid(columns: gridItems, spacing: spacing) {
            // Pillars
            ForEach(pillars) { pillar in
                NavigationLink(value: NavigationData<Self, Pillar>(data: pillar)) {
                    PillarTile(pillar: pillar)
                }
                .buttonStyle(.plain)
            }
            
            // Add tile
            IconTile(icon: "plus", sizeFactor: 30/393) {
                createPillar = true
            }
        }
        .padding(.bottom)
    }
}

//
//  MilestoneAndPlanningList.swift
//  GoalPilot
//
//  Created by Rune Pollet on 09/06/2024.
//

import SwiftUI
import SwiftData

/// Represents all milestones and their respective plannings.
struct MilestoneAndPlanningList: View {
    @Environment(NavigationViewModel.self) private var navigationModel
    
    @State var milestones: [Milestone]
    var editable: Bool = false
    var selectPlanningOfMilestone: ((Milestone) -> Void)?
    
    @Query(Milestone.descriptor()) private var persistedMilestones: [Milestone]
    @State private var selectedMilestone: Milestone?
    @State private var dragItem: Milestone?
    
    var body: some View {
        ScrollView {
            Grid(horizontalSpacing: 17, verticalSpacing: 0) {
                // Pruple star representing the goal
                GridRow {
                    StarFigure.StarShape()
                        .frame(width: 27, height: 27)
                        .foregroundStyle(Color(AssetsCatalog.goalColorID))
                        .padding(.bottom, 5)
                }
                
                // Arrow pointing to the goal
                GridRow {
                    Image(systemName: "arrow.up")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(AssetsCatalog.tertiaryOverlayColorID))
                        .frame(width: 27)
                        .padding(.vertical, 5)
                }
                
                ForEach(milestones) { milestone in
                    // Milestone
                    milestoneGridRow(milestone)
                        .padding(.vertical, dragItem == nil ? 0 : 10)
                    
                    // Planning
                    if dragItem == nil {
                        planningGridRow(milestone)
                    }
                }
            }
            .rearrangeable()
            .padding(.horizontal)
        }
        .scrollDisabled(dragItem != nil)
        .contentMargins(.vertical, 10, for: .scrollContent)
        .navigationDestination(for: Milestone.self) { milestone in
            MilestoneDetailView(milestone: milestone)
        }
        .onChange(of: persistedMilestones) {
            milestones = persistedMilestones
        }
        .onAppear {
            navigationModel.isEditing = editable
        }
    }
    
    private func milestoneGridRow(_ milestone: Milestone) -> some View {
        GridRow {
            Text("\(milestone.orderIndex)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.primary)
            
            HStack(spacing: 10) {
                NavigationLink(value: milestone) {
                    Group {
                        if !editable {
                            Image(systemName: milestone.achieved ? "checkmark.square.fill" : "square")
                                .imageScale(.large)
                                .foregroundStyle(milestone.achieved ? Color.accentColor : .secondary)
                        }
                        Text(milestone.title)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(Color.primary)
                            .fontWeight(.regular)
                    }
                    .drillIn()
                }
                .buttonStyle(.tappable)
                
                if editable {
                    Grabber()
                        .rearrange(milestone: milestone, milestones: $milestones, dragItem: $dragItem)
                }
            }
            .asListRow()
            .highlightStroke()
            .tileShadow()
        }
    }
    
    private func planningGridRow(_ milestone: Milestone) -> some View {
        GridRow {
            Capsule()
                .frame(width: 5)
                .frame(width: 27)
                .foregroundStyle(Color(AssetsCatalog.tertiaryOverlayColorID))
                .padding(.vertical, 5)
            if milestone.planning == nil {
                Button {
                    selectPlanningOfMilestone?(milestone)
                } label: {
                    planningLabel(milestone.planning)
                }
                .buttonStyle(.noAnimation)
            } else {
                planningLabel(milestone.planning)
            }
        }
    }
    
    private func planningLabel(_ planning: Planning?) -> some View {
        HStack(spacing: 5) {
            Text(planning?.title ?? "Create Planning")
                .font(.callout)
                .padding(.vertical)
            if planning == nil {
                Image(systemName: "chevron.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 11)
            }
        }
        .foregroundStyle(Color.secondary)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


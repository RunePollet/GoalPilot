//
//  MilestoneRearrangeable.swift
//  GoalPilot
//
//  Created by Rune Pollet on 15/09/2024.
//

import SwiftUI
import SwiftData

struct MilestoneRearrangeableModifier: ViewModifier {
    @Environment(\.modelContext) private var modelContext
    
    var milestone: Milestone
    @Binding var milestones: [Milestone]
    @Binding var dragItem: Milestone?
    
    @State private var selectionFeedback = false
    @State private var impactFeedback = false
    
    func body(content: Content) -> some View {
        content
            .sensoryFeedback(.selection, trigger: selectionFeedback)
            .sensoryFeedback(.impact, trigger: impactFeedback)
            .rearrange(onStarted: {
                impactFeedback.toggle()
                withAnimation(.smooth) {
                    self.dragItem = milestone
                }
            }, isTargeted: {
                if let dragItem, dragItem != milestone, let sourceIndex = milestones.firstIndex(of: dragItem), let destinationIndex = milestones.firstIndex(of: milestone) {
                    withAnimation(.bouncy) {
                        let sourceItem = milestones.remove(at: sourceIndex)
                        milestones.insert(sourceItem, at: destinationIndex)
                    }
                    
                    updateOrderIndices()
                    
                    selectionFeedback.toggle()
                }
            }, onEnded: {
                impactFeedback.toggle()
                withAnimation(.smooth) {
                    self.dragItem = nil
                }
                updateOrderIndices()
            })
    }
    
    func updateOrderIndices() {
        milestones = milestones.map { milestone in
            let index = (milestones.count-1) - milestones.firstIndex(of: milestone)!
            milestone.orderIndex = index+1
            return milestone
        }
        
        Milestone.updateOrderIndices(in: modelContext)
    }
}

extension View {
    /// An implementation of the rearrangable modifier specifically for a list of milestones.
    func milestoneRearrangeable(milestone: Milestone, milestones: Binding<[Milestone]>, dragItem: Binding<Milestone?>) -> some View {
        modifier(MilestoneRearrangeableModifier(milestone: milestone, milestones: milestones, dragItem: dragItem))
    }
}

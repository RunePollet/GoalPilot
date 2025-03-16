//
//  ReadSizing.swift
//  GoalPilot
//
//  Created by Rune Pollet on 26/06/2024.
//

import SwiftUI

struct ReadSizing: Layout, ViewModifier {
    var computeProposal: (@Sendable (ProposedViewSize) -> ProposedViewSize?)?
    var computeSizeThatFits: (@Sendable (CGSize) -> CGSize?)?
    
    nonisolated func body(content: Content) -> some View {
        ReadSizing(computeProposal: computeProposal, computeSizeThatFits: computeSizeThatFits) {
            content
        }
    }
    
    nonisolated func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let subview = subviews[0]
        
        // Compute the proposal
        let computedProposal = computeProposal?(proposal)
        
        // Compute sizeThatFits
        let sizeThatFits = subview.sizeThatFits(computedProposal ?? proposal)
        let computedSizeThatFits = computeSizeThatFits?(sizeThatFits)
        
        return computedSizeThatFits ?? sizeThatFits
    }
    
    nonisolated func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let subview = subviews[0]
        subview.place(at: bounds.origin, proposal: proposal)
    }
    
}

extension View {
    /// Reads the proposed size for this view and its size that fits based on that proposal and lets you compute these values if you want.
    func readSizing(computeProposal: (@Sendable (ProposedViewSize) -> ProposedViewSize?)? = nil, computeSizeThatFits: (@Sendable (CGSize) -> CGSize?)? = nil) -> some View {
        self.modifier(ReadSizing(computeProposal: computeProposal, computeSizeThatFits: computeSizeThatFits))
    }
}

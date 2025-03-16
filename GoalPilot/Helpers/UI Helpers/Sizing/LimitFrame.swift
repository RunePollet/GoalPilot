//
//  LimitFrame.swift
//  GoalPilot
//
//  Created by Rune Pollet on 09/05/2024.
//

import SwiftUI

struct LimitFrame: Layout, ViewModifier {
    var maxWidth: CGFloat?
    var maxHeight: CGFloat?
    var minWidth: CGFloat?
    var minHeight: CGFloat?
    var alignment: Alignment
    
    func body(content: Content) -> some View {
        LimitFrame(maxWidth: maxWidth, maxHeight: maxHeight, minWidth: minWidth, minHeight: minHeight, alignment: alignment) {
            content
        }
    }
    
    nonisolated func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let content = subviews[0]
        var result: CGSize = .zero
        
        // Define proposal with given max values
        let proposalWidth = numberBetween(max: maxWidth, min: minWidth, value: proposal.width)
        let proposalHeight = numberBetween(max: maxHeight, min: minHeight, value: proposal.height)
        let newProposal: ProposedViewSize = .init(width: proposalWidth, height: proposalHeight)
        
        // Ask required size
        let requiredSize = content.sizeThatFits(newProposal)
        
        // Compare required size with given values
        let width: CGFloat = numberBetween(max: maxWidth, min: minWidth, value: requiredSize.width)
        let height: CGFloat = numberBetween(max: maxHeight, min: minHeight, value: requiredSize.height)
        result = .init(width: width, height: height)
        
        // Return result
        return result
    }
    
    nonisolated func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let content = subviews[0]
        
        // Calculate leading and top constraints
        let dimensions = content.dimensions(in: .init(width: bounds.width, height: bounds.height))
        var xOffset: CGFloat {
            switch alignment.horizontal {
            case .leading:
                return 0
            case .trailing:
                return bounds.width
            default:
                return bounds.width / 2
            }
        }
        var yOffset: CGFloat {
            switch alignment.vertical {
            case.top:
                return 0
            case .bottom:
                return bounds.height
            default:
                return bounds.height / 2
            }
        }
        
        let leading = bounds.minX + xOffset - dimensions[alignment.horizontal]
        let top = bounds.minY + yOffset - dimensions[alignment.vertical]
        
        // Place the content at that position with the bounds as its proposed size
        content.place(at: .init(x: leading, y: top), anchor: .topLeading, proposal: .init(width: bounds.width, height: bounds.height))
    }
    
    nonisolated func numberBetween(max maxValue: CGFloat?, min minValue: CGFloat?, value: CGFloat?) -> CGFloat {
        let maxLimit = maxValue ?? .infinity
        let minLimit = minValue ?? .zero
        let value = value ?? (maxLimit != .infinity ? .infinity : .zero)
        
        return min(maxLimit, max(value , minLimit))
    }
}

extension View {
    /// Limits the frame to be within the specified range.
    func limitFrame(maxWidth: CGFloat? = nil, maxHeight: CGFloat? = nil, minWidth: CGFloat? = nil, minHeight: CGFloat? = nil, alignment: Alignment = .center) -> some View {
        modifier(LimitFrame(maxWidth: maxWidth, maxHeight: maxHeight, minWidth: minWidth, minHeight: minHeight, alignment: alignment))
    }
    
    @available(*, deprecated, message: "Please specify at least one more parameter.")
    func limitFrame(alignment: Alignment = .center) -> some View {
        modifier(LimitFrame(alignment: alignment))
    }
}

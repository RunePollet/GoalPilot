//
//  Percentage.swift
//  GoalPilot
//
//  Created by Rune Pollet on 05/04/2024.
//

import SwiftUI

@MainActor
public enum Dimension {
    case width
    case height
    case minDimension
    
    var rawValue: CGFloat {
        switch self {
        case .width:
            return WindowService.screenSize().width
        case .height:
            return WindowService.screenSize().height
        case .minDimension:
            return WindowService.screenSize().minDimension
        }
    }
}

/// Returns the product of the given factor and the specified screen dimension.
@MainActor
public func pct(_ factor: CGFloat, of dimension: Dimension) -> CGFloat {
    return dimension.rawValue * factor
}

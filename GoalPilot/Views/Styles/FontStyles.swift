//
//  FontStyles.swift
//  GoalPilot
//
//  Created by Rune Pollet on 25/03/2024.
//

import SwiftUI

// Custom fonts
extension Font {
    static func milestoneOrderIndexBold(size: CGFloat) -> Font {
        Font.system(size: size, weight: .bold, design: .rounded)
    }
    
    static func milestoneOrderIndex(size: CGFloat) -> Font {
        Font.system(size: size, weight: .semibold, design: .rounded)
    }
}

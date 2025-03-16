//
//  CGSizeHelpers.swift
//  GoalPilot
//
//  Created by Rune Pollet on 02/09/2024.
//

import SwiftUI

extension CGSize {
    /// The smallest of the two dimensions.
    var minDimension: CGFloat {
        self.width > self.height ? self.height : self.width
    }
    
    /// The largest of the two dimensions.
    var maxDimension: CGFloat {
        self.width < self.height ? self.height : self.width
    }
}

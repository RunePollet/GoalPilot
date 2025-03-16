//
//  PaddingStyles.swift
//  GoalPilot
//
//  Created by Rune Pollet on 30/04/2024.
//

import SwiftUI

/// Contains data of a predifined padding.
struct PaddingStyle {
    var leading: CGFloat
    var trailing: CGFloat
    var top: CGFloat
    var bottom: CGFloat
    
    private init(leading: CGFloat, trailing: CGFloat, top: CGFloat, bottom: CGFloat) {
        self.leading = leading
        self.trailing = trailing
        self.top = top
        self.bottom = bottom
    }
}

// Predefined padding styles
extension PaddingStyle {
    /// A predifined padding suitable for a text field.
    static let textField: PaddingStyle = .init(leading: 10, trailing: 10, top: 7, bottom: 7)
    
    /// A predifined padding suitable for an item row in a ScrollView.
    static let itemRow: PaddingStyle = .init(leading: 16, trailing: 16, top: 11, bottom: 11)
}

extension View {
    nonisolated func padding(_ edges: Edge.Set = .all, style: PaddingStyle) -> some View {
        self
            .padding(edges.subtracting([.trailing, .vertical]), style.leading)
            .padding(edges.subtracting([.leading, .vertical]), style.trailing)
            .padding(edges.subtracting([.bottom, .horizontal]), style.top)
            .padding(edges.subtracting([.top, .horizontal]), style.bottom)
    }
}

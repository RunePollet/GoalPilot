//
//  ScrollViewStyles.swift
//  GoalPilot
//
//  Created by Rune Pollet on 04/06/2024.
//

import SwiftUI

extension View {
    /// Adds styling to this view object to make it look like a list row.
    func asListRow(active: Bool = true, drillIn showDrillIn: Bool = false, color: Color = .accentColor, systemImage: String = "chevron.right", padding: Edge.Set = .all) -> some View {
        drillIn(active: showDrillIn && active, color: color, systemImage: systemImage)
            .padding(active ? padding : [], style: .itemRow)
            .background {
                if active {
                    ListRowBackground()
                }
            }
    }
    
    /// Adds a stroke to this list row to highlight it.
    func highlightStroke(color: Color = .accentColor, hidden: Bool = false) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(color, lineWidth: 1)
                .opacity(hidden ? 0 : 1)
        )
    }
}

/// A background view used to mimic the background of an elment in SwiftUI List.
struct ListRowBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(Color(uiColor: .secondarySystemGroupedBackground))
    }
    
    func shape() -> RoundedRectangle {
        RoundedRectangle(cornerRadius: 10)
    }
}

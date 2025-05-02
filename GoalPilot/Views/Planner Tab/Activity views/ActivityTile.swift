//
//  ActivityTile.swift
//  GoalPilot
//
//  Created by Rune Pollet on 07/07/2024.
//

import SwiftUI

/// A summary of the given activity in a tile.
struct ActivityTile: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var activity: Activity
    var canBeCompleted: Bool
    var isEditing: Bool
    var completeAction: (() -> Void)? = nil
    
    @State private var showDoneButton: Bool = true
    
    var body: some View {
        Tile(title: activity.subtitle,
             timeInterval: interval(),
             color: activity.color,
             customSection: {
            doneButton
        })
        .onChange(of: canBeCompleted, initial: true) { oldValue, newValue in
            showDoneButton = newValue
        }
    }
    
    /// Sets the achieved status of this activity for this week.
    private var doneButton: some View {
        Group {
            if showDoneButton {
                TileDoneButton {
                    withAnimation {
                        showDoneButton = false
                    }
                    completeAction?()
                }
                .foregroundStyle(colorScheme == .dark ? Color.black.opacity(0.6) : Color.secondary)
                .disabled(isEditing)
            }
        }
        .animation(.easeInOut, value: showDoneButton)
    }
    
    func interval() -> String {
        let startDate = Calendar.current.date(from: activity.startTimeComponents)
        let endDate = Calendar.current.date(from: activity.endTimeComponents)
        guard let startDate, let endDate else { return "-:- - -:-" }
        return startDate.interval(end: endDate)
    }
}

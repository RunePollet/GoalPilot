//
//  ActivityRow.swift
//  GoalPilot
//
//  Created by Rune Pollet on 27/01/2025.
//

import SwiftUI

/// Displays an activity event in one line.
struct ActivityRow: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var activity: Activity
    var minimalist: Bool
    var canBeCompleted: Bool
    var showTimeInterval: Bool = true
    var completeAction: (() -> Void)? = nil
    
    @State private var showDoneButton = true
    private var interval: String {
        let calendar = Calendar.current
        return calendar.date(from: activity.startTimeComponents)!.interval(end: calendar.date(from: activity.endTimeComponents)!, compact: true)
    }
    
    var body: some View {
        HStack {
            SmallPlanningEventRow(minimalist: minimalist, color: activity.color, title: activity.subtitle, timestamp: showTimeInterval ? interval : nil)
            
            if showDoneButton {
                TileDoneButton {
                    withAnimation {
                        showDoneButton = false
                    }
                    completeAction?()
                }
                .foregroundStyle(.secondary)
            }
        }
        .onChange(of: canBeCompleted, initial: true) { oldValue, newValue in
            showDoneButton = newValue
        }
    }
}

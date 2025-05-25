//
//  DetailedPathListItem.swift
//  GoalPilot
//
//  Created by Rune Pollet on 28/11/2024.
//

import SwiftUI
import SwiftData

/// A tile which shows the current event of a planning.
struct DetailedPathListItem: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    @Environment(StreakViewModel.self) private var streakModel
    
    var planning: Planning
    var activityDoneAction: (Activity) -> Void
    
    private let calendar = Calendar.current
    @Query private var currentReminders: [Reminder]
    private var currentActivities: [Activity] {
        planning.currentActivities()
    }
    
    init(planning: Planning, activityDoneAction: @escaping (Activity) -> Void) {
        self.planning = planning
        self.activityDoneAction = activityDoneAction
        let now = Date.now.timeIntervalSinceReferenceDate
        self._currentReminders = Query(.init(predicate: #Predicate { reminder in
            reminder.deadlineTimeIntervalSinceReferenceDate < now
        }))
    }
    
    var body: some View {
        VStack(spacing: 10) {
            // Planning title
            Text(planning.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.secondary)
            
            // Current event
            ForEach(currentActivities) { activity in
                ActivityRow(activity: activity, minimalist: false, canBeCompleted: !streakModel.completedActivities.contains(activity.id)) {
                    activityDoneAction(activity)
                }
            }
            ForEach(currentReminders) { reminder in
                HStack {
                    SmallPlanningEventRow(minimalist: false, color: reminder.color, title: reminder.subtitle, timestamp: reminder.refDeadline.formatted(date: .omitted, time: .shortened))
                    TileDoneButton {
                        withAnimation {
                            reminder.delete(from: modelContext)
                        }
                    }
                    .foregroundStyle(.secondary)
                }
            }
        }
        .padding(style: .itemRow)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .conditional(colorScheme == .dark) {
                    $0.foregroundStyle(.black.opacity(0.4))
                }
                .conditional(colorScheme != .dark) {
                    $0.foregroundStyle(.regularMaterial)
                }
        }
        .animation(.smooth, value: currentActivities)
        .animation(.smooth, value: currentReminders)
    }
}


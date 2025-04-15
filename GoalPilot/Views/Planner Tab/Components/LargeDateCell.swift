//
//  LargeDateCell.swift
//  GoalPilot
//
//  Created by Rune Pollet on 29/10/2024.
//

import SwiftUI
import SwiftData

/// A date cell suitable for displaying dates in a grid.
struct LargeDateCell: View {
    @Environment(\.modelContext) private var modelContext
    
    var date: Date
    var planning: Planning
    
    @State private var events: [any PlanningEvent] = []
    private let calendar = Calendar.current
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .foregroundStyle(Color(uiColor: .secondarySystemGroupedBackground))
            
            VStack(spacing: 7) {
                // Day
                HStack(alignment: .lastTextBaseline) {
                    Spacer()
                    Text(dateFormatter(dateFormat: "EEE").string(from: date))
                        .font(.system(size: 8))
                    Text(dateFormatter(dateFormat: "d").string(from: date))
                        .fontWeight(date.isToday ? .black : .regular)
                }
                .foregroundStyle(.secondary)
                
                // Activities and notifications
                ForEach(Array(events.enumerated()), id: \.offset) { (i, event) in
                    let maxEventRows = 4
                    
                    if i <= maxEventRows-1 {
                        eventRow(event: event)
                    } else if i == maxEventRows {
                        Text("...")
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding(10)
        }
        .onChange(of: planning, initial: true) {
            let weekday = calendar.component(.weekday, from: date)
            events = planning.getAllEvents(forWeekday: weekday, dayID: date.dayID, from: modelContext)
        }
    }
    
    @ViewBuilder
    private func eventRow(event: any PlanningEvent) -> some View {
        if let activity = event as? Activity {
            ActivityRow(activity: activity, minimalist: true, canBeCompleted: false)
        }
        else if let notification = event as? RecurringNote {
            SmallPlanningEventRow(color: notification.color, title: notification.subtitle)
        }
        else {
            let reminder = event as! Reminder
            SmallPlanningEventRow(color: reminder.color, title: reminder.subtitle)
        }
    }
    
    private func dateFormatter(dateFormat: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter
    }
}

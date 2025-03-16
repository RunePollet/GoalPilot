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
                ForEach(events, id: \.persistentModelID) { event in
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
            }
            .padding(10)
        }
        .onAppear {
            let weekday = calendar.component(.weekday, from: date)
            events = planning.getAllEvents(forWeekday: weekday, dayID: date.dayID, from: modelContext)
        }
    }
    
    func dateFormatter(dateFormat: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter
    }
}

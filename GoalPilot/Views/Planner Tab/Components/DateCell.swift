//
//  DateCell.swift
//  GoalPilot
//
//  Created by Rune Pollet on 07/10/2024.
//

import SwiftUI

/// A date cell suitable for displaying a single date in a horizontal chain of dates.
struct DateCell: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var date: Date
    var index: Int
    var displayedDates: [Date]
    
    let id = UUID().uuidString
    var lhs: Bool {
        guard let previousDate = displayedDates.previous(before: index) else { return false }
        return previousDate < Date.now
    }
    var rhs: Bool {
        guard let nextDate = displayedDates.next(after: index) else { return false }
        return nextDate < Date.now
    }
    
    var body: some View {
        VStack(spacing: 2) {
            // Weekday
            Text(dateFormatter(dateFormat: "EE").string(from: date).uppercased())
                .font(.system(size: 13, weight: date.isToday ? .heavy : .regular))
                .foregroundStyle(.secondary)
            // Day
            Text(dateFormatter(dateFormat: "dd").string(from: date))
                .font(.system(size: 15, weight: date.isToday ? .heavy : .semibold))
                .foregroundStyle(date < Date.now ? (colorScheme == .light ? .white : .black) : .secondary)
                .padding(6)
                .background {
                    if date < Date.now {
                        Circle()
                            .foregroundStyle(Color.accentColor)
                    }
                }
                .anchorPreference(key: AnchorPreference.self, value: .bounds) { anchor in
                    return [id: anchor]
                }
        }
        .padding(.horizontal, 7.5)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .backgroundPreferenceValue(AnchorPreference.self) { value in
            GeometryReader { geo in
                let anchor = value[id]
                let bounds: CGRect = {
                    guard let anchor else { return .zero }
                    return geo[anchor]
                }()
                
                HStack {
                    Rectangle()
                        .opacity(lhs && date < Date.now ? 1 : 0)
                    Rectangle()
                        .opacity(rhs && date < Date.now ? 1 : 0)
                }
                .foregroundStyle(Color.accentColor)
                .frame(height: 4)
                .position(x: bounds.midX, y: bounds.midY)
            }
        }
    }
    
    func dateFormatter(dateFormat: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter
    }
}

private struct AnchorPreference: PreferenceKey {
    static let defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        for (key, anchor) in nextValue() {
            value[key] = anchor
        }
    }
}

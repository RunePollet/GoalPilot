//
//  DateHelpers.swift
//  GoalPilot
//
//  Created by Rune Pollet on 20/10/2024.
//

import Foundation

// Accessibility
extension Date {
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(self)
    }
    
    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }
}

// Day Identifier
extension Date {
    /// A string identifier uniform over all date values of the same day.
    var dayID: String {
        return Self.dayIDFormatter.string(from: self)
    }
    
    /// Converts the given day id into its respecitve date at 00:00 or nil if the given id has the wrong format (yyyy-MM-dd zzz).
    static func getFromDayID(_ dayID: String) -> Date? {
        return Self.dayIDFormatter.date(from: dayID)
    }
    
    private static var dayIDFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd zzz"
        dateFormatter.timeZone = .gmt
        return dateFormatter
    }
}

// Descriptions
extension Int {
    /// The description of the integer as a weekday.
    var weekdayDescription: String? {
        switch self {
        case 1:
            return "sunday"
        case 2:
            return "monday"
        case 3:
            return "tuesday"
        case 4:
            return "wednesday"
        case 5:
            return "thursday"
        case 6:
            return "friday"
        case 7:
            return "saturday"
        default:
            return nil
        }
    }
}

extension Date {
    /// Returns a string describing an interval between this date and the end date.
    func interval(end: Date, compact: Bool = false) -> String {
        let start = self.formatted(date: .omitted, time: .shortened)
        let end = end.formatted(date: .omitted, time: .shortened)
        return compact ? "\(start)-\(end)" : "\(start) - \(end)"
    }
}

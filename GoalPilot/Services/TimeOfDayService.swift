//
//  TimeOfDayService.swift
//  GoalPilot
//
//  Created by Rune Pollet on 17/01/2025.
//

import SwiftUI

/// Service that indicates the current time of day.
class TimeOfDayService {
    enum TimeOfDay {
        case sunrise, day, sunset, night
        
        var preferredColorScheme: ColorScheme {
            switch self {
            case .day, .sunrise:
                return .light
            case .night, .sunset:
                return .dark
            }
        }
    }
    
    /// Returns the current time of day.
    static func current() -> TimeOfDay {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour >= 6 && hour < 9 {
            return .sunrise
        } else if hour >= 9 && hour < 18 {
            return .day
        } else if hour >= 19 && hour < 24 {
            return .sunset
        } else {
            return .night
        }
    }
}

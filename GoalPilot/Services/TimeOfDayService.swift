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
        let startMorning = 7
        let startDay = 9
        let startEvening = 19
        let startNight = 24
        if hour >= startMorning && hour < startDay {
            return .sunrise
        } else if hour >= startDay && hour < startEvening {
            return .day
        } else if hour >= startEvening && hour < startNight {
            return .sunset
        } else {
            return .night
        }
    }
}

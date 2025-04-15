//
//  RecurringPlanningEvent.swift
//  GoalPilot
//
//  Created by Rune Pollet on 15/04/2025.
//

import Foundation

/// A model that represents a recurring event of a planning.
protocol RecurringPlanningEvent: PlanningEvent {
    var weekday: Int { get set }
}

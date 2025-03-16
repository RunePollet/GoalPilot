//
//  PlanningEvent.swift
//  GoalPilot
//
//  Created by Rune Pollet on 02/11/2024.
//

import Foundation
import SwiftData

/// A model that represents an event of a planning.
protocol PlanningEvent: PersistentModel, SDColorDefaultable {
    associatedtype FetchResult: PersistentModel
    
    /// A date by adding up all relevant date components for the start of this event.
    var refDeadline: Date { get set }
    /// A date by adding up all relevant date components for the end of this event.
    var refEnd: Date? { get set }
    /// Returns a date by adding up all relevant date components of the given date to compare with the reference dates of this planning event.
    static func referenceDate(for date: Date) -> Date
    /// A predicate to fetch this model for the given weekday and planning.
    static func eventDescriptor(planning: Planning?, weekday: Int?) -> FetchDescriptor<FetchResult>
}

// Default options
extension PlanningEvent {
    var refEnd: Date? {
        get { nil }
        set { }
    }
}

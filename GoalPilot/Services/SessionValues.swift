//
//  SessionValues.swift
//  GoalPilot
//
//  Created by Rune Pollet on 22/06/2024.
//

import Foundation

/// Data storage that persists data for the current session.
actor SessionValues {
    private var values: [String : any Sendable] = [:]
    
    private init() {}
    static let shared = SessionValues()
    
    subscript(key: String) -> (any Sendable)? {
        get {
            return values[key]
        }
        set {
            values[key] = newValue
        }
    }
    
    func reset(key: String) {
        values[key] = nil
    }
    
    func set(_ value: any Sendable, forKey key: String) {
        values[key] = value
    }
    
    func value(forKey key: String) -> (any Sendable)? {
        values[key]
    }
}

//
//  StringHelpers.swift
//  GoalPilot
//
//  Created by Rune Pollet on 07/07/2024.
//

import SwiftUI

// Bound string
extension Optional where Wrapped == String {
    var _boundString: String? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    /// A binding to a optional string.
    public var boundString: String {
        get {
            return _boundString ?? ""
        }
        set {
            _boundString = newValue.isEmpty ? nil : newValue
        }
    }
}

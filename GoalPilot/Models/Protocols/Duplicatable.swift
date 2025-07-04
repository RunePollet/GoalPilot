//
//  Duplicatable.swift
//  GoalPilot
//
//  Created by Rune Pollet on 15/04/2025.
//

import Foundation

/// An object that can duplicate itself and its values.
protocol Duplicatable {
    /// Duplicates this object and its values.
    func duplicate() -> Self
}

//
//  Persistent.swift
//  GoalPilot
//
//  Created by Rune Pollet on 29/11/2024.
//

import Foundation

/// A view model that persists some or all of its data.
protocol Persistent {
    /// Saves all the persisted data of this view model.
    func save()
    
    /// Restores all the persisted data of this view model.
    func restore()
}

//
//  File.swift
//  GoalPilot
//
//  Created by Rune Pollet on 19/01/2025.
//

import SwiftData

extension ModelContext {
    /// Checks if the model context for changes and saves them.
    func saveChanges() {
        if hasChanges {
            do {
                try save()
            } catch {
                print("Error saving model context: \(error.localizedDescription)")
            }
        }
    }
}

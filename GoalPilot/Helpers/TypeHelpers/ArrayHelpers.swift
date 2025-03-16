//
//  ArrayHelpers.swift
//  GoalPilot
//
//  Created by Rune Pollet on 08/07/2024.
//

import Foundation

extension Array {
    /// Returns the next element after the given index.
    func next(after index: Int) -> Element? {
        let newIndex = index + 1
        guard (0..<self.count).contains(newIndex) else { return nil }
        return self[newIndex]
    }
    
    /// Returns the previous element before the given index.
    func previous(before index: Int) -> Element? {
        let newIndex = index - 1
        guard (0..<self.count).contains(newIndex) else { return nil }
        return self[newIndex]
    }
}

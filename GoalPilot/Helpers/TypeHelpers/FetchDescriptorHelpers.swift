//
//  FetchDescriptorHelpers.swift
//  GoalPilot
//
//  Created by Rune Pollet on 13/11/2024.
//

import Foundation
import SwiftData

extension FetchDescriptor {
    /// A fetch descriptor that fetches no values.
    static var empty: Self {
        return .init(predicate: #Predicate<T> { _ in return false })
    }
}

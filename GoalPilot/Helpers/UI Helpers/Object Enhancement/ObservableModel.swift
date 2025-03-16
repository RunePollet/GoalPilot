//
//  ObservableModel.swift
//  GoalPilot
//
//  Created by Rune Pollet on 13/11/2024.
//

import Foundation

/// An observable object wrapper.
@Observable
class ObservableModel<T: Hashable>: Hashable {
    var model: T
    
    init(_ model: T) {
        self.model = model
    }
    
    static func == (lhs: ObservableModel<T>, rhs: ObservableModel<T>) -> Bool {
        lhs.model == rhs.model
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(model)
    }
}

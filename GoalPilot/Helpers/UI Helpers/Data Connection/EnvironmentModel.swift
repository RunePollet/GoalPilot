//
//  EnvironmentModel.swift
//  GoalPilot
//
//  Created by Rune Pollet on 28/01/2025.
//

import SwiftUI

/// Retrieves the environment value of the type of the given model and exposes this value its content completion.
struct EnvironmentModel<T: Observable & AnyObject, U: View>: View {
    @Environment(T.self) private var model: T
    var content: (T) -> U
    
    init(_ model: T.Type, content: @escaping (T) -> U) {
        self.content = content
    }
    
    var body: some View {
        content(model)
    }
}


//
//  BindingHelpers.swift
//  GoalPilot
//
//  Created by Rune Pollet on 18/07/2025.
//

import Foundation
import SwiftUI

extension Binding {
    subscript<T>(_ keyPath: ReferenceWritableKeyPath<Value, T>) -> Binding<T> {
        .init(
            get: { self.wrappedValue[keyPath: keyPath] },
            set: { self.wrappedValue[keyPath: keyPath] = $0 }
        )
    }
    
    subscript<T: Equatable>(_ keyPath: ReferenceWritableKeyPath<Value, T?>, default defaultValue: T) -> Binding<T> {
        .init(
            get: { self.wrappedValue[keyPath: keyPath] ?? defaultValue },
            set: { self.wrappedValue[keyPath: keyPath] = $0 == defaultValue ? nil : $0 }
        )
    }
    
    subscript<T>(_ keyPath: WritableKeyPath<Value, T>) -> Binding<T> {
        .init(
            get: { self.wrappedValue[keyPath: keyPath] },
            set: { self.wrappedValue[keyPath: keyPath] = $0 }
        )
    }
    
    subscript<T: Equatable>(_ keyPath: WritableKeyPath<Value, T?>, default defaultValue: T) -> Binding<T> {
        .init(
            get: { self.wrappedValue[keyPath: keyPath] ?? defaultValue },
            set: { self.wrappedValue[keyPath: keyPath] = $0 == defaultValue ? nil : $0 }
        )
    }
}

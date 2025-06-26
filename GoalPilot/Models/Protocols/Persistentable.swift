//
//  Persistentable.swift
//  GoalPilot
//
//  Created by Rune Pollet on 05/09/2024.
//

import Foundation
import SwiftData

/// Provides model specific functions for inserting, deleting and management.
protocol Persistentable: PersistentModel {
    /// Whether the model will be deleted from the persistent store.
    var isDeleted: Bool { get set }
    
    /// Whether the values represent a configured object of this type.
    var isConfigured: Bool { get }
    
    /// Sets the given value for the given property in a transaction within the given model context.
    func establishRelationship<T: PersistentModel>(for property: ReferenceWritableKeyPath<Self, T?>, with model: T, within modelContext: ModelContext)
    
    /// Inserts this model in the given model context and does any additional set up.
    func insert(into modelContext: ModelContext)
    
    /// Deletes this model from the given model context and does any additional clean up.
    func delete(from modelContext: ModelContext)
    
    /// This function is called right before the model is deleted.
    func preDeletion(_ modelContext: ModelContext)
    
    /// Returns a fetch descriptor to fetch all relevant models of this type.
    static func descriptor() -> FetchDescriptor<Self>
}

// Default implementation
extension Persistentable {
    func establishRelationship<T: PersistentModel>(for property: ReferenceWritableKeyPath<Self, T?>, with model: T, within modelContext: ModelContext) {
        do {
            try modelContext.transaction {
                self[keyPath: property] = model
            }
        } catch {
            print("Failed to establish relationship for \(property.debugDescription) with \(model): \(error.localizedDescription)")
        }
    }
    
    func insert(into modelContext: ModelContext) {
        do {
            try modelContext.transaction { modelContext.insert(self) }
        } catch {
            print("Model insertion failed: \(error.localizedDescription)")
        }
    }
    
    func delete(from modelContext: ModelContext) {
        // Run the preDeletion
        preDeletion(modelContext)
        
        // Flag the deletion
        isDeleted = true
        
        // Delete the model
        do {
            try modelContext.transaction {
                modelContext.delete(self)
            }
        } catch {
            print("Model deletion failed: \(error.localizedDescription)")
        }
    }
    
    func preDeletion(_ modelContext: ModelContext) {}
}

// Correct access support
extension Persistentable {
    /// The underlying value if it isn't flagged as deleted.
    var activeValue: Self? { // !! weak is to control references --> it expects ONLY A CLASS TYPE, but Self is a protocol so can be a struct, enum etc. + weak DOESN'T HAVE EFFECT ON COMPUTED PROPERTIES as they aren't stored, so any references to a class within it are deleted when exiting its scope !!
        isDeleted ? nil : self
    }
}

extension Array where Element: Persistentable {
    /// The collection filtered for the elements that aren't flagged as deleted.
    var activeValues: Self {
        self.filter { !$0.isDeleted }
    }
}

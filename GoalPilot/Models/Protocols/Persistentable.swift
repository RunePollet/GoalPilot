//
//  Persistentable.swift
//  GoalPilot
//
//  Created by Rune Pollet on 05/09/2024.
//

import Foundation
import SwiftData

/// Provides model specific functions for inserting and deleting.
protocol Persistentable: PersistentModel {
    associatedtype FetchResult: PersistentModel
    
    /// Inserts this model in the given model context and does any additional set up.
    func insert(into modelContext: ModelContext)
    
    /// Deletes this model from the given model context and does any additional clean up.
    func delete(from modelContext: ModelContext)
    
    /// This function is called right before the model is deleted.
    func preDeletion(_ modelContext: ModelContext)
    
    /// Returns a fetch descriptor to fetch all relevant models of this type.
    static func descriptor() -> FetchDescriptor<FetchResult>
    
    /// Whether the model will be deleted from the persistent store.
    var isDeleted: Bool { get set }
    
    /// Whether the values represent a configured object of this type.
    var isConfigured: Bool { get }
}

// Default implementation
extension Persistentable {
    func insert(into modelContext: ModelContext) {
        modelContext.insert(self)
        modelContext.saveChanges()
    }
    
    func delete(from modelContext: ModelContext) {
        // Run the preDeletion
        preDeletion(modelContext)
        
        // Flag the deletion
        isDeleted = true
        
        // Delete the model
        modelContext.delete(self)
        modelContext.saveChanges()
    }
    
    func preDeletion(_ modelContext: ModelContext) {}
    
    static func descriptor() -> FetchDescriptor<Self> {
        let predicate = #Predicate<Self> { !$0.isDeleted }
        return FetchDescriptor(predicate: predicate)
    }
}

// Correct access support
extension Persistentable {
    /// The underlying value if it isn't flagged as deleted.
    var activeValue: Self? { // !! weak is to control references --> it expects ONLY A CLASS TYPE, but Self is a protocol so can be a struct, enum etc. + weak DOESN'T HAVE EFFECT ON COMPUTED PROPERTIES as they aren't stored, so any references to a class within it are deleted when exiting its scope !!
        isDeleted == false ? self : nil
    }
}

extension Array where Element: Persistentable {
    /// The collection filtered for the elements that aren't flagged as deleted.
    var activeValues: Self {
        self.filter { !$0.isDeleted }
    }
}

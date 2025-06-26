//
//  Milestone.swift
//  GoalPilot
//
//  Created by Rune Pollet on 16/06/2024.
//
//

import Foundation
import SwiftData

@Model
final class Milestone: Persistentable {
    #Unique<Milestone>([\.orderIndex])
    
    var id: UUID
    var title: String
    var info: String?
    var orderIndex: Int
    var achieved: Bool
    var isDeleted: Bool
    var parent: Goal?
    
    @Relationship(inverse: \Pillar._milestones)
    var _pillars: [Pillar]
    var pillars: [Pillar] {
        get { _pillars.activeValues }
        set { _pillars = newValue }
    }
    
    @Relationship(deleteRule: .cascade, inverse: \Planning._parent)
    var _planning: Planning?
    var planning: Planning? {
        get { isDeleted ? nil : _planning?.activeValue }
        set { _planning = newValue }
    }
    
    init(orderIndex: Int = 0) {
        self.id = UUID()
        self.title = ""
        self.orderIndex = orderIndex
        self._pillars = []
        self.achieved = false
        self.isDeleted = false
    }
    
    
    // MARK: Accessibilities
    static func updateOrderIndices(in modelContext: ModelContext) {
        do {
            try modelContext.transaction {
                let milestones = Self.getAll(from: modelContext).reversed()
                var counter = 1
                milestones.forEach { milestone in
                    milestone.orderIndex = counter
                    counter += 1
                }
            }
        } catch {
            print("Failed to update order indices of milestones: \(error.localizedDescription)")
        }
    }
    
    /// Creates a star configuration from the values of this milestone.
    var asStarConfiguration: Landscape.LandscapeView.StarConfiguration {
        .init(number: orderIndex, reached: achieved)
    }
    
    
    // MARK: Fetch Support
    /// Retrieves all milestones from the given model context in reversed order using orderIndex.
    static func getAll(from modelContext: ModelContext) -> [Milestone] {
        return (try? modelContext.fetch(Self.descriptor())) ?? []
    }
    
    
    // MARK: Persistentable
    func insert(into modelContext: ModelContext) {
        let goal = Goal.get(from: modelContext)
        self.orderIndex = goal.highestOrderIndex+1
        
        do {
            try modelContext.transaction { modelContext.insert(self) }
        } catch {
            print("Milestone insertion failed: \(error.localizedDescription)")
        }
        
        Self.updateOrderIndices(in: modelContext)
    }
    
    func delete(from modelContext: ModelContext) {
        isDeleted = true
        
        do {
            try modelContext.transaction { modelContext.delete(self) }
        } catch {
            print("Milestone deletion failed: \(error.localizedDescription)")
        }
        
        Self.updateOrderIndices(in: modelContext)
    }
    
    /// Returns a fetch descriptor to fetch all relevant milestones.
    var isConfigured: Bool { !title.isEmpty && parent != nil }
    
    static func descriptor() -> FetchDescriptor<Milestone> {
        let onlyPersisted = #Predicate<Milestone> { !$0.isDeleted }
        let orderIndexReversed = SortDescriptor(\Milestone.orderIndex, order: .reverse)
        return FetchDescriptor<Milestone>(predicate: onlyPersisted, sortBy: [orderIndexReversed])
    }
}

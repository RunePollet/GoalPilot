//
//  Pillar.swift
//  GoalPilot
//
//  Created by Rune Pollet on 16/06/2024.
//
//

import Foundation
import SwiftData

@Model
final class Pillar: Persistentable {
    var id: UUID
    var creationDate: Date
    var title: String
    var info: String?
    var icon: String
    var imageData: Data?
    var isDeleted: Bool
    var parent: Goal?
    
    var _milestones: [Milestone]
    var milestones: [Milestone] {
        get { _milestones.activeValues }
        set { _milestones = newValue }
    }
    
    init() {
        self.id = UUID()
        self.creationDate = Date()
        self.title = ""
        self.icon = "flag.square"
        self.isDeleted = false
        self._milestones = []
    }
    
    
    // MARK: Persistentable
    var isConfigured: Bool { !title.isEmpty && parent != nil }
    
    static func descriptor() -> FetchDescriptor<Pillar> {
        let predicate = #Predicate<Pillar> { !$0.isDeleted }
        return FetchDescriptor(predicate: predicate)
    }
}

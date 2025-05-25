//
//  Requirement.swift
//  GoalPilot
//
//  Created by Rune Pollet on 16/06/2024.
//
//

import Foundation
import SwiftData

@Model
final class Requirement: Persistentable {
    var id: UUID
    var creationDate: Date
    var title: String
    var info: String?
    var isDeleted: Bool
    var parent: Goal?
    
    init() {
        self.id = UUID()
        self.creationDate = Date()
        self.title = ""
        self.isDeleted = false
    }
    
    
    // MARK: Persistentable
    var isConfigured: Bool { parent != nil && !title.isEmpty }
}

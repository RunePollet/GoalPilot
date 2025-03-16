//
//  Particle.swift
//  GoalPilot
//
//  Created by Rune Pollet on 05/01/2024.
//

import SwiftUI

/// Represents a particle in the ParticleSystem.
struct Particle: Hashable {
    var size: CGSize = CGSize()
    var color: Color = .white
    var origin: UnitPoint = UnitPoint()
    var target: UnitPoint = UnitPoint()
    var removalDate: Date = Date()
    let creationDate: Date = Date.now
}

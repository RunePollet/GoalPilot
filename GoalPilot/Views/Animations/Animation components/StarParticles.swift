//
//  StarParticles.swift
//  GoalPilot
//
//  Created by Rune Pollet on 05/01/2024.
//

import SwiftUI

extension StarFigure {
    /// An application of the particle system that uses the star shape as particles.
    struct StarParticles<U: Shape>: View {
        var target: UnitPoint
        var particleSize: CGSize
        var particleShape: U
        var spawnParticle: (Date) -> Bool
        var color: (Date) -> Color
        var killCompletion: () -> Void
        
        @State private var particleSystem = ParticleSystem()
        
        var body: some View {
            TimelineView(.animation) { timeline in
                Canvas { canvasContext, canvasSize in
                    // Update the particle system
                    var newParticle: Particle? = nil
                    if spawnParticle(timeline.date) {
                        newParticle = Particle(size: particleSize,
                                               color: self.color(timeline.date),
                                               origin: particleSystem.randomPointOffScreen(margin: 0.005),
                                               target: target,
                                               removalDate: .now + 1)
                    }
                    particleSystem.update(date: timeline.date, newParticle: newParticle, killCompletion: self.killCompletion)
                    
                    // Draw the particles
                    for particle in particleSystem.particles {
                        let position = particleSystem.calculateMovement(particle: particle, date: timeline.date, size: canvasSize)
                        let rect = CGRect(x: position.x, y: position.y, width: particle.size.width, height: particle.size.height)
                        let shape = particleShape.path(in: rect)
                        
                        var contextCopy = canvasContext
                        contextCopy.addFilter(.shadow(color: particle.color, radius: 5))
                        contextCopy.fill(shape, with: .color(particle.color))
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}

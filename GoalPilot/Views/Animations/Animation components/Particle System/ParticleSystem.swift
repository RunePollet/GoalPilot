//
//  ParticleSystem.swift
//  GoalPilot
//
//  Created by Rune Pollet on 05/01/2024.
//

import SwiftUI

@Observable
class ParticleSystem {
    var particles = Set<Particle>()
    
    /// Adds a new particle if provided and kills any overdue particles.
    func update(date: Date, newParticle: Particle?, killCompletion: (() -> Void)? = nil) {
        // Remove any particles
        particles = particles.filter { particle in
            if particle.removalDate < date {
                killCompletion?()
                return false
            }
            return true
        }
        
        // Add a particle
        if let newParticle = newParticle {
            particles.insert(newParticle)
        }
    }
    
    /// Calculates the position in the given size at which a particle should move to reach its target at its removal date.
    func calculateMovement(particle: Particle, date: Date, size: CGSize) -> UnitPoint {
        // Calculate the distance the particle has to travel
        let target = UnitPoint(x: particle.target.x*size.width - particle.size.width/2, y: particle.target.y*size.height - particle.size.height/2)
        let totalXDistance = target.x - (particle.origin.x * size.width)
        let totalYDistance = target.y - (particle.origin.y * size.height)
        
        // Calculate the progress
        let age = particle.creationDate.distance(to: date)
        let lifespan = particle.creationDate.distance(to: particle.removalDate)
        let progress = age/lifespan
        
        // Calculate the total movement for this particle using the progress
        let movementX = totalXDistance * progress
        let movementY = totalYDistance * progress
        
        // Return the final position of the particle
        let originX = particle.origin.x * size.width
        let originY = particle.origin.y * size.height
        return UnitPoint(x: originX + movementX, y: originY + movementY)
    }
    
    /// A random UnitPoint within the screen bounds.
    func randomPointOnScreen() -> UnitPoint {
        let x = CGFloat.random(in: 0...1)
        let y = CGFloat.random(in: 0...1)
        return UnitPoint(x: x, y: y)
    }
    
    /// Returns a random UnitPoint outside of the screen bounds taking a relative margin into account.
    func randomPointOffScreen(margin: CGFloat) -> UnitPoint {
        var x = 0.0
        var y = 0.0
        let xFirst = Bool.random()
        
        switch xFirst {
        case true:
            x = CGFloat.random(in: -margin...1+margin)
            if x < 0 || x > 1 {
                y = CGFloat.random(in: -margin...1+margin)
            } else {
                if Bool.random() {
                    y = 1+margin
                } else {
                    y = -margin
                }
            }
            
        case false:
            y = CGFloat.random(in: -margin...1+margin)
            if y < 0 || y > 1 {
                x = CGFloat.random(in: -margin...1+margin)
            } else {
                if Bool.random() {
                    x = 1+margin
                } else {
                    x = -margin
                }
            }
        }
        
        return UnitPoint(x: x, y: y)
    }
    
    func killAllParticles() {
        self.particles.removeAll()
    }
}

//
//  StarIndicator.swift
//  GoalPilot
//
//  Created by Rune Pollet on 07/03/2024.
//

import SwiftUI

extension Landscape {
    /// Holds values describing a star indicator.
    struct StarIndicator: Identifiable {
        var id = UUID()
        
        var origin: CGPoint
        var backgroundColor: Color
    }
}

extension Landscape.StarIndicator {
    static let firstHill: Self = .init(
        origin: CGPoint(x: 206.0/393.0, y: 251.0/292.0),
        backgroundColor: Color(AssetsCatalog.firstHillColorID)
    )
    
    static let secondHillFirst: Self = .init(
        origin: CGPoint(x: 144.0/393.0, y: 178.0/292.0),
        backgroundColor: Color(AssetsCatalog.secondHillColorID)
    )
    
    static let secondHillSecond: Self = .init(
        origin: CGPoint(x: 43.0/393.0, y: 206.0/292.0),
        backgroundColor: Color(AssetsCatalog.secondHillColorID)
    )
    
    static let thirdHill: Self = .init(
        origin: CGPoint(x: 65.0/393.0, y: 74.0/292.0),
        backgroundColor: Color(AssetsCatalog.thirdHillColorID)
    )
}

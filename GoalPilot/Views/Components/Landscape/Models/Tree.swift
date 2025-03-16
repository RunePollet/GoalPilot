//
//  Tree.swift
//  GoalPilot
//
//  Created by Rune Pollet on 07/03/2024.
//

import SwiftUI

extension Landscape {
    /// Holds values describing a tree on a hill.
    struct Tree: Identifiable {
        enum Style {
            case light, dark
        }
        
        var id = UUID()
        
        var canopyColor: Color
        var leafColor: Color
        var footColor: Color
        var scale: CGFloat
        var offset: CGSize
        
        init(style: Self.Style, footColor: Color, scale: CGFloat, offset: CGSize) {
            self.canopyColor = style == .light ? Color(AssetsCatalog.canopyColorID) : Color(AssetsCatalog.secondaryCanopyColorID)
            self.leafColor = style == .light ? Color(AssetsCatalog.secondaryCanopyColorID) : Color(AssetsCatalog.canopyColorID)
            self.footColor = footColor
            self.scale = scale
            self.offset = offset
        }
    }
}

extension Landscape.Tree {
    static let firstHillLeft: Self = .init(
        style: .light,
        footColor: Color(AssetsCatalog.secondHillColorID),
        scale: 1.2,
        offset: CGSize(width: 20.91/393.0, height: 65.91/122.0)
    )
    
    static let firstHillRight: Self = .init(
        style: .dark,
        footColor: Color(AssetsCatalog.secondHillColorID),
        scale: 1.1,
        offset: CGSize(width: 335.0/393.0, height: 22.0/122.0)
    )
    
    static let fourthHill: Self = .init(
        style: .light,
        footColor: Color(AssetsCatalog.secondHillColorID),
        scale: 1.0,
        offset: CGSize(width: 62.34/180.34, height: -11.0/103.93)
    )
    
    static let firstOnboardingHillTrees: [Self] = [
        .init(style: .dark,
              footColor: Color(AssetsCatalog.secondHillColorID),
              scale: 1.4,
              offset: CGSize(width: 1852.0/3930.0, height: 26.13/191.0)),
        .init(style: .light,
              footColor: Color(AssetsCatalog.secondHillColorID),
              scale: 1.4,
              offset: CGSize(width: 2276.0/3930.0, height: 10.13/191.0)),
        .init(style: .dark,
              footColor: Color(AssetsCatalog.secondHillColorID),
              scale: 1.4,
              offset: CGSize(width: 2437.0/3930.0, height: 21.13/191.0)),
        .init(style: .light,
              footColor: Color(AssetsCatalog.secondHillColorID),
              scale: 1.4,
              offset: CGSize(width: 3062.0/3930.0, height: 95.13/191.0)),
        .init(style: .dark,
              footColor: Color(AssetsCatalog.secondHillColorID),
              scale: 1.4,
              offset: CGSize(width: 3430.0/3930.0, height: 107.13/191.0))
    ]
    
    static let secondOnboardingHillTrees: [Self] = [
        .init(style: .light,
              footColor: Color(AssetsCatalog.firstHillColorID),
              scale: 1.2,
              offset: CGSize(width: 15.0/3930.0, height: 217.8/434.8)),
        .init(style: .dark,
              footColor: Color(AssetsCatalog.firstHillColorID),
              scale: 1.2,
              offset: CGSize(width: 325.0/3930.0, height: 317.8/434.8)),
        .init(style: .light,
              footColor: Color(AssetsCatalog.firstHillColorID),
              scale: 1.2,
              offset: CGSize(width: 703.0/3930.0, height: 338.8/434.8)),
        .init(style: .light,
              footColor: Color(AssetsCatalog.firstHillColorID),
              scale: 1.2,
              offset: CGSize(width: 842.0/3930.0, height: 315.8/434.8)),
        .init(style: .dark,
              footColor: Color(AssetsCatalog.firstHillColorID),
              scale: 1.2,
              offset: CGSize(width: 1107.0/3930.0, height: 211.8/434.8)),
        .init(style: .light,
              footColor: Color(AssetsCatalog.firstHillColorID),
              scale: 1.2,
              offset: CGSize(width: 1261.0/3930.0, height: 290.8/434.8)),
        .init(style: .dark,
              footColor: Color(AssetsCatalog.firstHillColorID),
              scale: 1.2,
              offset: CGSize(width: 2097.0/3930.0, height: 22.8/434.8)),
        .init(style: .light,
              footColor: Color(AssetsCatalog.firstHillColorID),
              scale: 1.2,
              offset: CGSize(width: 2689.0/3930.0, height: 168.8/434.8)),
        .init(style: .light,
              footColor: Color(AssetsCatalog.firstHillColorID),
              scale: 1.2,
              offset: CGSize(width: 3204.0/3930.0, height: 130.8/434.8)),
        .init(style: .dark,
              footColor: Color(AssetsCatalog.firstHillColorID),
              scale: 1.2,
              offset: CGSize(width: 3863.0/3930.0, height: 222.8/434.8))
    ]
    
    static let thirdOnboardingHillTrees: [Self] = [
        .init(style: .light,
              footColor: Color(AssetsCatalog.secondHillColorID),
              scale: 1,
              offset: CGSize(width: 2839.0/3930.0, height: 166.0/852.0)),
        .init(style: .dark,
              footColor: Color(AssetsCatalog.secondHillColorID),
              scale: 1,
              offset: CGSize(width: 3562.0/3930.0, height: 511.0/852.0))
    ]
}

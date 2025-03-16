//
//  StarWithEyesView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 26/12/2023.
//

import SwiftUI

extension StarFigure {
    /// The view of a star figure.
    struct StarView: View {
        var config: StarViewConfiguration = StarViewConfiguration()
        
        var body: some View {
            GeometryReader { geo in
                ZStack {
                    StarShapeView(geo: geo, star: config.star)
                        .foregroundStyle(Color(config.character == .goal ? AssetsCatalog.goalColorID : AssetsCatalog.accentColorID))
                    
                    // Left Eye
                    ZStack {
                        EyeView(geo: geo, eye: config.leftEye)
                            .offset(y: geo.size.height * -5/300)
                        
                        EyebrowView(geo: geo, eyebrow: config.leftEyebrow)
                    }
                    .offset(x: geo.size.width * -35/300)
                    
                    // Right Eye
                    ZStack {
                        EyeView(geo: geo, eye: config.rightEye)
                            .offset(y: geo.size.height * -5/300)
                        
                        EyebrowView(geo: geo, eyebrow: config.rightEyebrow)
                    }
                    .offset(x: geo.size.width * 35/300)
                    
                    // Mouth
                    MouthView(geo: geo, mouth: config.mouth)
                        .offset(y: geo.size.height * 5/300)
                }
                .frame(width: geo.size.minDimension, height: geo.size.minDimension)
                .foregroundStyle(
                    config.character == .goal ? Color(AssetsCatalog.goalColorID) : Color(AssetsCatalog.starBlueColorID),
                    config.character == .goal ? Color(AssetsCatalog.starEyeBrowPurpleColorID) : Color(AssetsCatalog.starEyeBrowBlueColorID))
            }
        }
    }
}

//
//  TakeABreakIcons.swift
//  GoalPilot
//
//  Created by Rune Pollet on 21/08/2024.
//

import SwiftUI

/// An icon which can be used along a text which message is about unclear thoughts.
struct CloudInHeadIcon: View {
    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                Image(systemName: "person")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.secondary)
                
                Image(systemName: "cloud.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geo.size.minDimension*0.25)
                    .offset(x: -geo.size.minDimension*0.005, y: -geo.size.minDimension*0.3)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
    }
}

/// An icon which can be used along a text which message is clear thoughts.
struct ClearHeadIcon: View {
    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                Image(systemName: "person")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Group {
                    Image(systemName: "sparkle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.minDimension*0.23)
                        .offset(x: geo.size.minDimension*0.22, y: -geo.size.minDimension*0.53)
                    
                    Image(systemName: "sparkle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.minDimension*0.08)
                        .offset(x: geo.size.minDimension*0.3, y: -geo.size.minDimension*0.4)
                    
                    Image(systemName: "sparkle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.minDimension*0.13)
                        .offset(x: -geo.size.minDimension*0.2, y: -geo.size.minDimension*0.5)
                }
                .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
    }
}


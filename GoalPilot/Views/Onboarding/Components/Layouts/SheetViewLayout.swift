//
//  SheetView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 17/04/2024.
//

import SwiftUI

enum SheetMode {
    case inspiration
    case example
}

/// The layout for a sheet view.
struct SheetViewLayout<Content: View>: View {
    @Environment(\.dismiss) private var dismiss
    
    var mode: SheetMode
    var intro: String?
    var title: String
    var titlePadding: CGFloat = 50/852
    @ViewBuilder var customSection: Content
    
    var body: some View {
        VStack {
            VStack(spacing: 10) {
                if intro != nil {
                    // Intro
                    Text(intro!)
                }
                
                // Title
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(.top, pct(titlePadding, of: .height))
            .padding(.horizontal)
            .padding(.bottom, pct(mode == .example ? titlePadding : 0, of: .height))
            
            if mode == .inspiration {
                Spacer()
            }
            
            customSection
            
            if mode == .inspiration {
                Spacer()
            }
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(SheetBackground())
        .navigationTitle(mode == .inspiration ? "Inspiration" : "Example")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { DoneToolbarItems(color: Color(AssetsCatalog.complementaryColorID)) }
    }
}

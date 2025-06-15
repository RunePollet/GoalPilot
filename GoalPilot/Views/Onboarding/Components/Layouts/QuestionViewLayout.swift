//
//  QuestionView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 19/04/2024.
//

import SwiftUI

/// The layout for a question view.
struct QuestionViewLayout<Content: View>: View {
    @Environment(OnboardingViewModel.self) private var onboardingModel
    
    struct Spacing {
        var top: CGFloat?
        var aboveTitle: CGFloat?
        var aboveCustomSection: CGFloat?
    }
    struct TextStyle {
        var font: Font?
        var color: Color?
    }
    
    var preText: (text: String, style: TextStyle)?
    var title: (text: String, style: TextStyle)
    var tip: (text: String, style: TextStyle)?
    @ViewBuilder var customSection: Content
    var spacing: Spacing = .init()
    
    var body: some View {
        
        VStack(spacing: 0) {
            Spacer()
                .limitFrame(maxHeight: spacing.top ?? pct(30/852, of: .height))
            
            if let preText {
                // Pretext
                Text(preText.text)
                    .foregroundStyle(preText.style.color ?? .white)
                    .font(preText.style.font ?? .body)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
            }
            
            Spacer()
                .limitFrame(maxHeight: spacing.aboveTitle ?? pct(preText == nil ? 114/852 : 40/852, of: .height))
            
            VStack(spacing: 10) {
                // Title
                Text(title.text)
                    .foregroundStyle(title.style.color ?? .white)
                    .font(title.style.font ?? .title)
                    .fontWeight(.bold)
                
                if let tip {
                    // Tip
                    Text(tip.text)
                        .foregroundStyle(tip.style.color ?? .white)
                        .font(tip.style.font ?? .subheadline)
                        .fontWeight(.semibold)
                        .opacity(0.6)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal)
            
            Spacer()
                .limitFrame(maxHeight: spacing.aboveCustomSection ?? pct(tip == nil ? 112/852 : 60/852, of: .height))
            
            // Custom section
            customSection
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
                .padding(.bottom)
            
            Spacer()
        }
        .multilineTextAlignment(.center)
        
    }
}

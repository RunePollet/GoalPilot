//
//  TextCarousel.swift
//  GoalPilot
//
//  Created by Rune Pollet on 06/01/2025.
//

import SwiftUI

/// Shows the given texts after each other for the given amount of time using the given transition.
struct TextCarousel: View {
    var texts: [String]
    var transition: AnyTransition = .opacity.animation(.easeInOut(duration: 0.7))
    var presentDuration: CGFloat = 2
    
    @State private var index = 0
    @State private var showText = true
    
    var body: some View {
        if showText && !texts.isEmpty {
            Text(texts[index])
                .transition(transition)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + presentDuration) {
                        withAnimation {
                            self.showText = false
                        }
                    }
                }
                .onDisappear {
                    if index+1 < texts.count {
                        self.index += 1
                        withAnimation {
                            self.showText = true
                        }
                    }
                }
        }
    }
}

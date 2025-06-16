//
//  ButtonStyles.swift
//  GoalPilot
//
//  Created by Rune Pollet on 31/07/2024.
//

import SwiftUI

// MARK: - PlaintappableButtonStyle
struct PlainTappableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(Color.primary)
            .background(TappableBackground())
    }
}

extension ButtonStyle where Self == PlainTappableButtonStyle {
    /// A plain button which is also tappable on not visible areas.
    static var tappable: PlainTappableButtonStyle { .init() }
}


// MARK: - NoAnimation
struct PlainNoAnimationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(Color.primary)
    }
}

extension ButtonStyle where Self == PlainNoAnimationButtonStyle {
    /// A plain button that doesn't have a tap animation.
    static var noAnimation: PlainNoAnimationButtonStyle { .init() }
}


// MARK: - SwitchingButtonStyles
extension Button {
    /// Switches between the first and second given button styles. If style is not given, no style will be applied.
    @ViewBuilder
    func switchingButtonStyles<ButtonStyle1: ButtonStyle>(apply: Bool, style1: ButtonStyle1) -> some View {
        if apply {
            self.buttonStyle(style1)
        } else {
            self
        }
    }
}

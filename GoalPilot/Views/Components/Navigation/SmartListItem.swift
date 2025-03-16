//
//  SmartListItem.swift
//  GoalPilot
//
//  Created by Rune Pollet on 27/10/2024.
//

import SwiftUI

/// Switches between a button and a navigation link with the same label.
struct SmartListItem<Content: View, SignatureContent: View>: View {
    var isButton: Bool
    var isActive: Bool = true
    var navigationValue: any Hashable
    var signature: Signature<SignatureContent>
    var buttonAction: (() -> Void)? = nil
    @ViewBuilder var label: Content
    
    var body: some View {
        if !isButton {
            SmartNavigationLink(isActive: isActive, tint: signature.tint, value: navigationValue, label: { label })
        } else {
            Button {
                buttonAction?()
            } label: {
                HStack {
                    label
                    Spacer()
                    signature.buttonSignature
                        .foregroundStyle(signature.tint)
                }
            }
            .buttonStyle(.tappable)
        }
    }
    
    /// The signature at the trailing edge of the smart list item.
    struct Signature<ButtonSignature: View> {
        var tint: Color = .accentColor
        @ViewBuilder var buttonSignature: ButtonSignature
    }
}

//
//  DismissKeyboardArea.swift
//  GoalPilot
//
//  Created by Rune Pollet on 15/04/2024.
//

import SwiftUI

extension View {
    /// Runs the closure when the tabs or drags down on this area.
    func dismissKeyboardArea(_ dismiss: @escaping () -> Void) -> some View {
        self
            .background(TappableBackground())
            .onTapGesture {
                // Dismiss the keyboard
                dismiss()
            }
            .gesture(
                // Provide a drag-down-to-dismiss-keyboard functionality
                DragGesture().onEnded { value in
                    if value.location.y > value.startLocation.y {
                        dismiss()
                    }
                }
            )
    }
}

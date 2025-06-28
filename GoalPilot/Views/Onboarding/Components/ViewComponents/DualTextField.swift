//
//  DualTextFieldView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 29/03/2024.
//

import SwiftUI

/// A text field which reveals a secondary text field when it is focused.
struct DualTextField: View {
    enum Field: Hashable {
        case first, second
    }
    
    @Binding var firstTextField: String
    var firstPrompt = "Title"
    @Binding var secondTextField: String
    var secondPrompt = "Description"
    var focusedField: FocusState<Self.Field?>.Binding
    
    @State private var showSecondTextField: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // First text field
            TextField(firstPrompt, text: $firstTextField)
                .focused(focusedField, equals: Self.Field.first)
                .zIndex(1)
                .frame(maxWidth: .infinity)
                .padding(style: .textField)
            
            // Second text field
            if showSecondTextField {
                Divider()
                    .zIndex(2)
                TextField(secondPrompt, text: $secondTextField, axis: .vertical)
                    .focused(focusedField, equals: Self.Field.second)
                    .zIndex(0)
                    .padding(style: .textField)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .tint(.secondary)
        .background(MaterialBackground())
        .clipped()
        .onChange(of: focusedField.wrappedValue) { _, newValue in
            withAnimation(.easeInOut) {
                self.showSecondTextField = newValue != nil
            }
        }
    }
}

//
//  OnboardingTextFieldStyle.swift
//  GoalPilot
//
//  Created by Rune Pollet on 29/03/2024.
//

import SwiftUI

struct OnboardingTextFieldStyle: TextFieldStyle {
    @Binding var input: String
    var focused: Bool
    var stretch: Bool = false
    
    @State private var showDelete: Bool = false
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack(alignment: .top, spacing: 0) {
            configuration
                .tint(input == "" ? Color.secondary : .white)
                .padding(style: .textField)
        }
        .frame(maxHeight: stretch ? .infinity : nil, alignment: .top)
        .background(MaterialBackground())
        .clipped()
        .onChange(of: focused) { _, newValue in
            withAnimation(.easeInOut(duration: 0.3)) {
                showDelete = newValue
            }
        }
    }
    
}

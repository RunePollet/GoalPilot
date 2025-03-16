//
//  InputView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 28/04/2024.
//

import SwiftUI

/// View to add a title and description to a list.
struct InputView: View {
    @Binding var firstInput: String
    var firstPrompt: String = "Title"
    @Binding var secondInput: String
    var secondPrompt: String = "Description"
    var focusedField: FocusState<DualTextField.Field?>.Binding
    var addCompletion: () -> Void
    
    @State private var curInputHeight: CGFloat = 0
    
    var body: some View {
        HStack(alignment: .top, spacing: 5) {
            DualTextField(firstTextField: $firstInput, firstPrompt: firstPrompt,
                          secondTextField: $secondInput, secondPrompt: secondPrompt,
                          focusedField: focusedField)
            .onTapGesture {}
            .zIndex(1)
            
            if !firstInput.isEmpty {
                addToListButton
                    .transition(.asymmetric(insertion: .scale.animation(.bouncy.delay(0.03)), removal: .scale))
            }
        }
        .animation(.smooth, value: firstInput)
        .background(
            ZStack(alignment: .top) {
                Rectangle()
                    .foregroundStyle(Color(AssetsCatalog.firstHillColorID))
                    .blur(radius: 3.0)
                Rectangle()
                    .foregroundStyle(Color(AssetsCatalog.firstHillColorID))
                    .frame(height: curInputHeight/2)
            }
        )
        .readFrame { frame in
            curInputHeight = frame.height
        }
    }
    
    private var addToListButton: some View {
        Button {
            firstInput = firstInput.trimmingCharacters(in: .whitespaces)
            secondInput = secondInput.trimmingCharacters(in: .whitespacesAndNewlines)
            addCompletion()
        } label: {
                Image(systemName: "plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.accentColor)
                    .frame(height: 18)
                    .fontWeight(.semibold)
                    .padding(9.5)
        }
    }
}

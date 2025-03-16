//
//  Editable.swift
//  GoalPilot
//
//  Created by Rune Pollet on 31/10/2024.
//

import SwiftUI

struct EditableModifier: ViewModifier {
    var isEditing: Bool
    var color: Color
    var completion: (() -> Void)? = nil
    
    func body(content: Content) -> some View {
        HStack {
            if isEditing {
                Image(systemName: "pencil")
                    .imageScale(.large)
                    .foregroundStyle(color)
                    .zIndex(1)
            }
            
            content
                .zIndex(2)
        }
        .onTapGesture {
            if isEditing {
                completion?()
            }
        }
    }
}

extension View {
    /// Adds an edit button on the leading side of the view when editing.
    func editable(isEditing: Bool, color: Color = .accentColor, completion: @escaping () -> Void) -> some View {
        modifier(EditableModifier(isEditing: isEditing, color: color, completion: completion))
    }
}

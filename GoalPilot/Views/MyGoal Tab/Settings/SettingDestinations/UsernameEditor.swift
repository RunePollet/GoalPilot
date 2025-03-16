//
//  UsernameEditor.swift
//  GoalPilot
//
//  Created by Rune Pollet on 15/03/2025.
//

import SwiftUI

struct UsernameEditor: View {
    @Environment(NavigationViewModel.self) private var navigationModel
    
    @FocusState var nameEditorFocused: Bool
    @State private var username = TextService.shared.username
    
    var body: some View {
        Form {
            TextField("Name", text: $username)
                .focused($nameEditorFocused)
                .submitLabel(.done)
                .onSubmit {
                    navigationModel.path.removeLast()
                }
        }
        .navigationTitle("Name")
        .onAppear {
            nameEditorFocused = true
        }
        .onDisappear {
            TextService.shared.username = username
        }
    }
}

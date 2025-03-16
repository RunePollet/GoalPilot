//
//  NavigationModelStack.swift
//  GoalPilot
//
//  Created by Rune Pollet on 16/11/2024.
//

import SwiftUI

/// A NavigationStack with its own NavigationViewModel as environment object.
struct NavigationModelStack<Content: View>: View {
    @ViewBuilder var content: () -> Content
    @State private var navigationModel: NavigationViewModel
    @State private var sheetIsPresented = false
    
    init(path: NavigationPath = .init(), isCreating: Bool = false, content: @escaping () -> Content) {
        self.content = content
        self.navigationModel = NavigationViewModel(path: path, isCreating: isCreating)
    }
    
    var body: some View {
        NavigationStack(path: $navigationModel.path) {
            content()
        }
        .environment(navigationModel)
    }
}

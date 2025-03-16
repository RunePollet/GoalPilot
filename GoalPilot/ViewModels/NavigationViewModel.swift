//
//  NavigationViewModel.swift
//  GoalPilot
//
//  Created by Rune Pollet on 27/10/2024.
//

import SwiftUI

/// A view model with info of its navigation stack.
@Observable
class NavigationViewModel {
    
    var path: NavigationPath
    let isCreating: Bool
    
    var hideEditButton: Bool
    var isEditing: Bool = false
    
    private var _hideTabBar: Bool?
    var hideTabBar: Bool {
        get { _hideTabBar ?? !path.isEmpty }
        set { _hideTabBar = newValue }
    }
    
    init(path: NavigationPath = .init(), isCreating: Bool = false, hideEditButton: Bool = false) {
        self.path = path
        self.isCreating = isCreating
        self.hideEditButton = hideEditButton
    }
}


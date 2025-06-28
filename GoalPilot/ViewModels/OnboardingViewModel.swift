//
//  OnboardingViewModel.swift
//  GoalPilot
//
//  Created by Rune Pollet on 28/03/2024.
//

import SwiftUI
import SwiftData

/// The view model that manages the onboarding sequence.
@Observable
class OnboardingViewModel: Persistent {
    enum Views: Int {
        case welcome = 1, intro, question1, question2, question3, question4, question5, question6, reward, endOnboarding
    }
    
    // View coordination
    private(set) var isOnboarding: Bool = true
    var isBeingReused = false
    
    var toolbars: [Views: OnboardingToolbar] = [:]
    
    // Navigation
    private(set) var currentView: OnboardingViewModel.Views = .welcome
    private(set) var pushEdge: Edge = .leading
    
    init() {
        restore()
    }
    
    func save() {
        saveIsOnboarding()
        saveCurrentView()
    }
    
    func restore() {
        restoreIsOnboarding()
        if isOnboarding {
            restoreCurrentView()
        }
    }
    
    /// Prepares the onboarding model to be reused to change the goal of the user and shows it in an overlay.
    func reuse() {
        self.isBeingReused = true
        self.currentView = .intro
        
        withAnimation {
            isOnboarding = true
        }
    }
}

// Accessors for isOnboarding
extension OnboardingViewModel {
    func restoreIsOnboarding() {
        if let fetchedValue = UserDefaults.standard.value(forKey: Keys.isOnboarding) as? Bool {
            isOnboarding = fetchedValue
        }
    }
    
    func dismissOnboarding(completion: (() -> Void)? = nil) {
        withAnimation {
            isOnboarding = false
        } completion: {
            completion?()
        }
    }
    
    func saveIsOnboarding() {
        UserDefaults.standard.setValue(isOnboarding, forKey: Keys.isOnboarding)
    }
}

// Accessors for currentView
extension OnboardingViewModel {
    @MainActor
    func nextView() {
        if let nextView = Views(rawValue: currentView.rawValue+1) {
            pushEdge = .trailing
            animateView(nextView: nextView)
        }
    }
    
    @MainActor
    func previousView() {
        if let previousView = Views(rawValue: currentView.rawValue-1) {
            pushEdge = .leading
            animateView(nextView: previousView)
        }
    }
    
    private func animateView(nextView: Views) {
        withAnimation(.easeInOut(duration: 1)) {
            currentView = nextView
        }
    }
    
    private func restoreCurrentView() {
        if let fetchedValue = UserDefaults.standard.value(forKey: Keys.currentView) as? Int, let fetchedView = Views(rawValue: fetchedValue) {
            currentView = fetchedView
        }
    }
    
    private func saveCurrentView() {
        UserDefaults.standard.setValue(currentView.rawValue, forKey: Keys.currentView)
    }
}

// Accessors for the tool bar properties
extension OnboardingViewModel {
    /// An object that describes a toolbar in the onboarding sequence.
    struct OnboardingToolbar: Equatable {
        var id: UUID = UUID()
        var nextButton: NextButton?
        var primaryButton: BottomBarButton?
        var secondaryButton: BottomBarButton?
        var infoButton: (() -> Void)?
        
        static func == (lhs: OnboardingToolbar, rhs: OnboardingToolbar) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    /// An object that describes a next button in the onboarding sequence.
    struct NextButton: Equatable {
        var id: UUID = UUID()
        var title: String = "Next"
        var isDisabled: () -> Bool = { false }
        var completion: (() -> Void)?
        
        static func == (lhs: NextButton, rhs: NextButton) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    /// An object that describes a bottom bar button in the onboarding sequence.
    struct BottomBarButton: Equatable {
        enum Style {
            case primary, secondary
        }
        
        var id: UUID = UUID()
        var title: String = "Next"
        var style: Self.Style = .primary
        var action: () -> Void
        var isDisabled: () -> Bool = { false }
        
        static func == (lhs: BottomBarButton, rhs: BottomBarButton) -> Bool {
            lhs.id == rhs.id
        }
    }
}


// Keys
private extension OnboardingViewModel {
    class Keys {
        static let isOnboarding = "IS_ONBOARDING"
        static let currentView = "CURRENT_VIEW"
        static let viewHistory = "VIEW_HISTORY"
    }
}

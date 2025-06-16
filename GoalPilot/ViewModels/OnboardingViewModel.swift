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
    
    var bottomBarSetter: (() -> Void)?
    var nextButton: BottomBarButton?
    var secondaryButton: BottomBarButton?
    var showDataRequiredWarning: Bool = false
    
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
            updateBottomBar(transitionForward: true)
        }
    }
    
    @MainActor
    func previousView() {
        if let previousView = Views(rawValue: currentView.rawValue-1) {
            pushEdge = .leading
            animateView(nextView: previousView)
            updateBottomBar(transitionForward: false)
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

// Accessors for the bottom bar properties
extension OnboardingViewModel {
    /// A model that describes a bottom bar button in the onboarding sequence.
    struct BottomBarButton: Equatable {
        enum Action {
            case next, dismiss, completionOnly
        }
        
        var title: String = "Next"
        var action: Self.Action = .next
        var completion: (() -> Void)? = nil
        var isDisabled: () -> Bool = { false }
        
        @MainActor
        func performAction(goal: Goal, onboardingModel: OnboardingViewModel, modelContext: ModelContext) {
            completion?()
            
            if action == .next {
                onboardingModel.nextView()
            } else if action == .dismiss {
                modelContext.saveChanges()
                if goal.isConfigured {
                    onboardingModel.dismissOnboarding()
                }
                else {
                    WindowService.window()?.presentAlert(.goalNotConfigured)
                }
            }
        }
        
        static func == (lhs: BottomBarButton, rhs: BottomBarButton) -> Bool {
            lhs.title == rhs.title && lhs.isDisabled() == rhs.isDisabled()
        }
    }
    
    /// Updates the bottom bar buttons to the current view.
    @MainActor
    func updateBottomBar(transitionForward: Bool = false) {
        withAnimation {
            nextButton = nil
            secondaryButton = nil
        } completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                withAnimation(.easeInOut(duration: 0.8).delay(self.currentView == .reward && transitionForward ? 0.8 : 0)) {
                    self.bottomBarSetter?()
                }
            }
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

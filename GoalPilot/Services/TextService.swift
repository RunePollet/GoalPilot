//
//  TextService.swift
//  GoalPilot
//
//  Created by Rune Pollet on 24/08/2024.
//

import Foundation

/// Stores text samples and the username.
@Observable
class TextService: Persistent {
    
    var username: String = ""
    
    // Text samples
    var motivatingExclamations: [String] {
        ["Here we go!", "Let's go!", "Give it your all \(username)!", "Let's do this!", "Keep it up \(username)!", "You've got this \(username)!", "Go for it \(username)!", "Let’s keep stoking those flames!", "Keep riding that wave \(username)!", "Let’s keep stacking them up!", "Let’s keep the fire burning!", "Keep that energy alive!", "You’ve got the current on your side, keep riding that tide \(username)!", "Keep it blazing!", "Keep the heat coming!", "Let’s keep the current flowing!", "Don’t lose that spark!", "Keep the charge going strong!", "Keep the shockwave rolling!", "Keep up the momentum \(username)!"]
    }
    var weeklyFeedbackExclamations: [String] {
        ["Excellent job this week!", "Great work this week!", "You’ve nailed it this week \(username)."]
    }
    func greetingBasedOnTimeOfDay(_ timeOfDay: TimeOfDayViewModel.TimeOfDay) -> String {
        let hour = Calendar.current.component(.hour, from: .now)
        switch timeOfDay {
        case .sunrise:
            return "Rise and shine, \(username)!"
        case .day:
            if hour < 12 {
                return "Good morning, \(username)"
            } else {
                return "Good afternoon, \(username)"
            }
        case .sunset:
            return "Good evening, \(username)"
        default:
            return "Good night, \(username)"
        }
    }
    
    @MainActor
    static let shared = TextService()
    private init() { restore() }
    
    func save() {
        // Save the username to user defaults
        UserDefaults.standard.set(username, forKey: Keys.username)
    }
    
    func restore() {
        // Restore the user name
        username = UserDefaults.standard.string(forKey: Keys.username) ?? ""
    }
}


// Keys
extension TextService {
    class Keys {
        static let username = "USERNAME"
    }
}

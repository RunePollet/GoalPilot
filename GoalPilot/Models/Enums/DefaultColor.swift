//
//  DefaultColor.swift
//  GoalPilot
//
//  Created by Rune Pollet on 25/08/2024.
//

import SwiftUI

/// Colors that can be used as placeholder colors.
enum DefaultColor: Int, Identifiable, CaseIterable, CustomStringConvertible {
    case red = 1, pink, purple, indigo, blue, cyan, accent, green, fluoGreen, yellow, orange, brown
    
    var color: Color {
        switch self {
        case .pink:
            return Color.pink.opacity(0.7)
        case .green:
            return Color.green.opacity(0.7)
        case .blue:
            return Color.blue.opacity(0.7)
        case .orange:
            return Color.orange.opacity(0.7)
        case .yellow:
            return Color.yellow.opacity(0.7)
        case .red:
            return Color.red.opacity(0.8)
        case .brown:
            return Color.brown.opacity(0.7)
        case .cyan:
            return Color.cyan.opacity(0.7)
        case .indigo:
            return Color.indigo.opacity(0.7)
        case .fluoGreen:
            return Color(red: 142/255, green: 251/255, blue: 128/255)
        case .purple:
            return Color(red: 195/255, green: 124/255, blue: 253/255)
        case .accent:
            return Color.accentColor
        }
    }
    
    var description: String {
        switch self {
        case .pink:
            return "pink"
        case .green:
            return "green"
        case .blue:
            return "blue"
        case .orange:
            return "orange"
        case .yellow:
            return "yellow"
        case .red:
            return "red"
        case .brown:
            return "brown"
        case .cyan:
            return "cyan"
        case .indigo:
            return "indigo"
        case .fluoGreen:
            return "fluo green"
        case .purple:
            return "purple"
        case .accent:
            return "blue accent"
        }
    }
    
    var id: Color {
        self.color
    }
    
    static func random() -> Self {
        return Self.init(rawValue: Int.random(in: 1...12)) ?? Self.yellow
    }
}

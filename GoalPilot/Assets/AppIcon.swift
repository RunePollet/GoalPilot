//
//  AppIcon.swift
//  GoalPilot
//
//  Created by Rune Pollet on 15/03/2025.
//

import SwiftUI

/// Represents a possible app icon.
enum AppIcon: String {
    case blue = "AppIconBlue"
    case purple = "AppIconPurple"

    var id: String { rawValue }
    var iconName: String? {
        switch self {
        case .blue:
            return nil
        default:
            return rawValue
        }
    }

    var preview: UIImage {
        UIImage(named: rawValue + "-Preview") ?? UIImage()
    }
}

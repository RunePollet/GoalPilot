//
//  SDColorDefaultable.swift
//  GoalPilot
//
//  Created by Rune Pollet on 21/01/2025.
//

import SwiftUI

/// A model that can have default color and save its color in Swift Data.
protocol SDColorDefaultable {
    var colorRed: CGFloat { get set }
    var colorGreen: CGFloat { get set }
    var colorBlue: CGFloat { get set }
    var colorAlpha: CGFloat { get set }
    var defaultColorRawValue: Int? { get set }
    
    /// The color represented by the red, green, blue and alpha properties.
    var color: Color { get set }
    
    /// The current default color of this object.
    var defaultColor: DefaultColor? { get set }
}

// Default implemention
extension SDColorDefaultable {
    var color: Color {
        get {
            if let defaultColor = defaultColor {
                return defaultColor.color
            }
            return Color(uiColor: UIColor(red: colorRed, green: colorGreen, blue: colorBlue, alpha: colorAlpha))
        }
        set {
            convertColor(newValue)
            defaultColorRawValue = nil
        }
    }
    
    var defaultColor: DefaultColor? {
        get {
            if let rawValue = defaultColorRawValue {
                return .init(rawValue: rawValue)
            } else {
                return nil
            }
        }
        set {
            defaultColorRawValue = newValue?.rawValue
        }
    }
    
    private mutating func convertColor(_ color: Color) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        colorRed = red
        colorGreen = green
        colorBlue = blue
        colorAlpha = alpha
    }
}


//
//  CurrentFirstResponder.swift
//  GoalPilot
//
//  Created by Rune Pollet on 28/06/2025.
//

import UIKit

private weak var _currentFirstResponder: UIResponder?

extension UIResponder {
    /// The current first responder if there is one.
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        // send action to find current first responder
        UIApplication.shared.sendAction(#selector(findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }

    @objc private func findFirstResponder(_ sender: AnyObject) {
        _currentFirstResponder = self
    }
}

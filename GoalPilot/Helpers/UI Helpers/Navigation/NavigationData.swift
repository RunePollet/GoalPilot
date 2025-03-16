//
//  NavigationData.swift
//  GoalPilot
//
//  Created by Rune Pollet on 11/11/2024.
//

import Foundation

/// A wrapper for navigation data to uniquely identify the underlying type.
struct NavigationData<Root, Data: Hashable>: Hashable {
    var data: Data
}

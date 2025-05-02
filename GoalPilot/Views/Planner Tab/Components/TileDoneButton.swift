//
//  TileDoneButton.swift
//  GoalPilot
//
//  Created by Rune Pollet on 28/11/2024.
//

import SwiftUI

/// A button which action will only be run after a time period so the user can cancel the action.
struct TileDoneButton: View {
    var completion: () -> Void
    
    @State private var isDone: Bool = false
    @State private var timer: Timer?
    
    var body: some View {
        Button {
            isDone.toggle()
            
            if isDone && timer == nil {
                timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in
                    DispatchQueue.main.async {
                        completion()
                    }
                })
            } else if !isDone {
                timer?.invalidate()
                timer = nil
            }
        } label: {
            Image(systemName: "checkmark")
                .imageScale(.small)
                .symbolVariant(isDone ? .square.fill : .square)
                .animation(.default, value: isDone)
        }
        .sensoryFeedback(.success, trigger: isDone) { oldValue, newValue in
            return newValue
        }
    }
}


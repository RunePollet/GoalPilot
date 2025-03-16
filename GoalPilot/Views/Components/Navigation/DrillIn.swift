//
//  DrillIn.swift
//  GoalPilot
//
//  Created by Rune Pollet on 02/10/2024.
//

import SwiftUI

extension View {
    /// Adds only the appearance of drill functionality to this view.
    func drillIn(active: Bool = true, color: Color = .accentColor, systemImage: String = "chevron.right") -> some View {
        HStack {
            self
            if active {
                Spacer()
                Image(systemName: systemImage)
                    .imageScale(.small)
                    .fontWeight(.semibold)
                    .foregroundStyle(color)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    /// Adds drill in functionality to this view.
    func drillIn(active: Bool = true, color: Color = .accentColor, systemImage: String = "chevron.right", completion: @escaping () -> Void) -> some View {
        self.drillIn(active: active, color: color, systemImage: systemImage)
            .background(TappableBackground())
            .conditional(active) { view in
                view.onTapGesture {
                    completion()
                }
            }
    }
}

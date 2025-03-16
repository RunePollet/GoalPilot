//
//  ExampleRow.swift
//  GoalPilot
//
//  Created by Rune Pollet on 01/05/2024.
//

import SwiftUI

/// The default row layout without functionality.
struct ExampleRow: View {
    var text: String
    
    var body: some View {
        Text(text)
            .foregroundStyle(Color.secondary)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(style: .textField)
            .background(MaterialBackground())
    }
}

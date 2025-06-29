//
//  DefaultColorPicker.swift
//  GoalPilot
//
//  Created by Rune Pollet on 25/08/2024.
//

import SwiftUI

struct DefaultColorPicker: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selection: DefaultColor?
    var subject: String?
    
    var body: some View {
        Form {
            Section {
                ForEach(DefaultColor.allCases) { defaultColor in
                    Button {
                        selection = defaultColor
                        dismiss()
                    } label: {
                        HStack {
                            Text(defaultColor.description.capitalized)
                            Spacer()
                            Circle()
                                .foregroundStyle(defaultColor.color)
                                .frame(height: 25)
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.accentColor)
                                .opacity(selection == defaultColor ? 1 : 0)
                        }
                    }
                    .buttonStyle(.tappable)
                }
            } header: {
                if let subject {
                    Text("Choosing for: \(subject)")
                        .foregroundStyle(Color.secondary)
                }
            }
        }
        .navigationTitle("Default Colors")
        .navigationBarTitleDisplayMode(.inline)
    }
}

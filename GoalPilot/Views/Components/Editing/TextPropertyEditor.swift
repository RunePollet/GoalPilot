//
//  TextPropertyEditor.swift
//  GoalPilot
//
//  Created by Rune Pollet on 08/07/2024.
//

import SwiftUI

struct TextPropertyEditor<Root: Hashable>: View {
    @Environment(\.dismiss) private var dismiss
    
    var model: Self.Model
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HighlightedList {
            Section {
                TextField(model.title,
                          text: .init(
                            get: { model.root[keyPath: model.keyPath] },
                            set: { newValue in
                                DispatchQueue.main.async {
                                    model.root[keyPath: model.keyPath] = newValue
                                }
                            }),
                          axis: model.axis)
                .focused($isFocused)
                .submitLabel(model.axis == .vertical ? .return : .done)
                .onSubmit {
                    dismiss()
                }
            } footer: {
                if let footer = model.footer {
                    Text(footer)
                }
            }
            .strokeHidden(model.highlightColor == nil)
            .tintColor(model.highlightColor ?? .clear)
            .hasShadow(model.highlightColor != nil)
        }
        .contentMargins(.top, 16, for: .scrollContent)
        .navigationTitle(model.title)
        .navigationBarTitleDisplayMode(.inline)
        .dismissKeyboardArea {
            isFocused = false
        }
        .onAppear { isFocused = true }
        .onDisappear {
            model.root[keyPath: model.keyPath] = model.root[keyPath: model.keyPath].trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    /// An object suitable for being used as a navigation value that contains information for a TextPropertyEditor.
    class Model: Hashable {
        var root: Root
        var keyPath: WritableKeyPath<Root, String>
        var title: String
        var footer: String?
        var axis: Axis = .horizontal
        var highlightColor: Color?
        
        init(root: Root, keyPath: WritableKeyPath<Root, String>, title: String, footer: String? = nil, axis: Axis = .horizontal, highlightColor: Color? = nil) {
            self.root = root
            self.keyPath = keyPath
            self.title = title
            self.footer = footer
            self.axis = axis
            self.highlightColor = highlightColor
        }
        
        static func == (lhs: Model, rhs: Model) -> Bool {
            lhs.root == rhs.root && lhs.keyPath == rhs.keyPath
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(root)
        }
        
        // Default options
        static func pathSummary(_ goal: Goal) -> TextPropertyEditor<Goal>.Model {
            .init(root: goal, keyPath: \.pathSummary.boundString, title: "Path summary", footer: "A path summary is a short text you can tell yourself everyday to remind you of your journey. It describes what you're goal exactly is, what you're going to do to achieve it and when you'll achieve it. This is a powerful tip to help you stay focused and motivated.\nSource: Think and Grow Rich - Napoleon Hill", axis: .vertical, highlightColor: .accentColor)
        }
        
        static func goalDescription(_ goal: Goal) -> TextPropertyEditor<Goal>.Model {
            .init(root: goal, keyPath: \.info.boundString, title: "Description", axis: .vertical, highlightColor: .accentColor)
        }
    }
}

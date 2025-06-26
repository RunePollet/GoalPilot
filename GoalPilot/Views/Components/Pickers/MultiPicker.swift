//
//  MultiPicker.swift
//  GoalPilot
//
//  Created by Rune Pollet on 04/05/2024.
//

import SwiftUI

/// A picker which lets the user choose multiple elements displayed in a sheet.
struct MultiPicker<Value: Equatable, Label: View, Row: View>: View {
    typealias DismissCompletion = (_ addedValues: [Value], _ removedValues: [Value]) -> Void
    
    @Binding var showing: Bool
    var content: [Value]
    @Binding var selection: [Value]
    var contentRow: (Value) -> Row
    var label: () -> Label
    var title: String?
    var subject: String?
    var footer: String?
    
    // View coordination
    @State private var showPicker = false
    @State private var selectables: [Selectable]
    @State private var removed: [Selectable] = []
    @State private var added: [Selectable] = []
    
    init(showing: (Binding<Bool>)? = nil, content: [Value], selection: Binding<[Value]>, contentRow: @escaping (Value) -> Row, label: @escaping () -> Label, title: String? = nil, subject: String? = nil, footer: String? = nil) {
        self._showing = showing ?? .constant(false)
        self.content = content
        self.selectables = content.map { Selectable(value: $0, isSelected: selection.wrappedValue.contains($0)) }
        self._selection = selection
        self.contentRow = contentRow
        self.label = label
        self.title = title
        self.subject = subject
        self.footer = footer
    }
    
    var body: some View {
        Button {
            showPicker = true
        } label: {
            label()
        }
        .buttonStyle(.tappable)
        .sheet(isPresented: $showPicker) {
            picker
        }
        .onChange(of: showPicker) { _, newValue in
            showing = newValue
        }
    }
    
    private var picker: some View {
        NavigationStack {
            Form {
                Section {
                    ForEach(Array(selectables.enumerated()), id: \.offset) { i, selectable in
                        Button {
                            // Select or deselect this value
                            selectDeselect(at: i)
                        } label: {
                            HStack(spacing: 5) {
                                contentRow(selectable.value)
                                
                                Spacer()
                                
                                if selectable.isSelected {
                                    Image(systemName: "checkmark")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.accentColor)
                                }
                            }
                        }
                        .buttonStyle(.tappable)
                    }
                } header: {
                    if let subject {
                        Text("Choosing for: \(subject)")
                    }
                } footer: {
                    if let footer {
                        Text(footer)
                            .foregroundStyle(Color.secondary)
                    }
                }
            }
            .navigationTitle(title ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                DoneToolbarItems(doneCompletion: { showPicker = false })
            }
        }
    }
    
    private func selectDeselect(at index: Int) {
        selectables[index].isSelected.toggle()
        selection = selectables.filter { $0.isSelected }.map { $0.value }
    }
}

private extension MultiPicker {
    struct Selectable: Identifiable {
        var value: Value
        var isSelected: Bool
        var id: UUID = UUID()
        
        init(value: Value, isSelected: Bool) {
            self.value = value
            self.isSelected = isSelected
        }
    }
}

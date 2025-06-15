//
//  NotificationForm.swift
//  GoalPilot
//
//  Created by Rune Pollet on 25/08/2024.
//

import SwiftUI

/// A form containing all data of a notification.
struct NotificationForm<T: NotificationRepresentable & PlanningEvent & Persistentable>: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var wrapper: ObservableModel<T>
    var date: Date
    var isCreating: Bool
    
    // View coordination
    @State private var isEnabled = true
    @State private var showDefaultColors = false
    @State private var showRemoveDialog = false
    
    var body: some View {
        Form {
            // Enabled
            if !isCreating {
                Toggle("Enabled", isOn: $wrapper.model.isEnabled)
                    .tint(.accentColor)
                    .disabled(NotificationService.shared.locked)
            }
            
            // Title, description and color
            Section {
                NavigationLink(value: TextPropertyEditor<ObservableModel<T>>.Model(root: wrapper, keyPath: \.model.subtitle, title: "Title")) {
                    LabeledContent("Title", value: wrapper.model.subtitle)
                }
                NavigationLink(value: TextPropertyEditor<ObservableModel<T>>.Model(root: wrapper, keyPath: \.model.body, title: "Title", axis: .vertical)) {
                    LabeledContent {
                        Text(wrapper.model.body)
                            .lineLimit(nil)
                    } label: {
                        Text("Description")
                    }
                }
                HStack {
                    // Color Picker
                    ColorPicker("Color", selection: $wrapper.model.color)
                    
                    // Placeholder Color Picker
                    Button {
                        showDefaultColors = true
                    } label: {
                        Image(systemName: "circle.badge.plus.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.accentColor, wrapper.model.defaultColor?.color ?? .secondary)
                            .imageScale(.large)
                            .fontWeight(.bold)
                    }
                }
                .lineLimit(1)
            }
            .labeledContentStyle(.plain)
            .foregroundStyle(.primary, Color.accentColor)
            
            // Deadline
            Section {
                DatePicker("Deadline", selection: $wrapper.model.refDeadline, displayedComponents: wrapper.model.displayedDateComponents)
            }
            
            if !isCreating {
                // Duplicate button
                if wrapper.model is RecurringNote {
                    Section {
                        NavigationLink(value: wrapper.model) {
                            Text("Duplicate")
                        }
                        .foregroundStyle(.primary, Color.accentColor)
                        .buttonStyle(.tappable)
                    }
                }
                
                // Remove button
                Button("Remove", role: .destructive) {
                    showRemoveDialog = true
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationDestination(for: TextPropertyEditor<ObservableModel<T>>.Model.self) { model in
            TextPropertyEditor(model: model)
        }
        .navigationDestination(for: RecurringNote.self) { recurringNote in
            DuplicationView(object: recurringNote, objectDisplayName: "Recurring Note")
        }
        .sheet(isPresented: $showDefaultColors) {
            NavigationStack {
                DefaultColorPicker(selection: $wrapper.model.defaultColor)
            }
        }
        .confirmationDialog("This cannot be undone", isPresented: $showRemoveDialog) {
            Button("Remove", role: .destructive) {
                wrapper.model.delete(from: modelContext)
                dismiss()
            }
        }
        .onAppear {
            // Set the deadline
            if isCreating {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.hour, .minute], from: .now)
                let date = calendar.date(byAdding: components, to: calendar.startOfDay(for: date)) ?? .now
                wrapper.model.refDeadline = date
            }
        }
    }
}


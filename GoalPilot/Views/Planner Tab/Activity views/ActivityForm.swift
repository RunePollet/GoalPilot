//
//  ActivityForm.swift
//  GoalPilot
//
//  Created by Rune Pollet on 14/07/2024.
//

import SwiftUI

/// A form containing all data of an activity.
struct ActivityForm: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State var activity: Activity
    var date: Date
    var isCreating: Bool
    
    @State private var showDefaultColors = false
    @State private var showRemoveDialog = false
    
    var body: some View {
        Group {
            Form {
                // Title, info and color
                Section {
                    NavigationLink(value: TextPropertyEditor<Activity>.Model(root: activity, keyPath: \.subtitle, title: "Title")) {
                        LabeledContent("Title", value: activity.subtitle)
                    }
                    NavigationLink(value: TextPropertyEditor<Activity>.Model(root: activity, keyPath: \.body, title: "Description", axis: .vertical)) {
                        LabeledContent("Description", value: activity.body)
                    }
                    HStack {
                        ColorPicker("Color", selection: .init(get: { self.activity.color }, set: { self.activity.color = $0 }))
                        
                        Button {
                            showDefaultColors = true
                        } label: {
                            Image(systemName: "circle.badge.plus.fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color.accentColor, activity.defaultColor?.color ?? .secondary)
                                .imageScale(.large)
                                .fontWeight(.bold)
                        }
                    }
                    .lineLimit(1)
                }
                .labeledContentStyle(.plain)
                .foregroundStyle(.primary, Color.accentColor)
                
                // Interval
                Section {
                    @Bindable var activity = activity
                    DatePicker("Start Time", selection: $activity.refDeadline, displayedComponents: activity.displayedDateComponents)
                    DatePicker("End Time", selection: .init(get: { activity.refEnd ?? activity.refDeadline+3600 }, set: { activity.refEnd = $0 }), displayedComponents: activity.displayedDateComponents)
                }
                
                // Notification
                Section("Notification") {
                    @Bindable var activity = activity
                    Toggle("Notification at start", isOn: $activity.isEnabled)
                        .tint(.accentColor)
                        .disabled(NotificationService.shared.locked)
                }
                
                // Remove button
                if !isCreating {
                    Button("Remove", role: .destructive) {
                        showRemoveDialog = true
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationDestination(for: TextPropertyEditor<Activity>.Model.self) { model in
                TextPropertyEditor(model: model)
            }
            .sheet(isPresented: $showDefaultColors) {
                NavigationStack {
                    DefaultColorPicker(selection: .init(get: { activity.defaultColor }, set: { activity.defaultColor = $0 }))
                }
            }
            .confirmationDialog("This action cannot be undone", isPresented: $showRemoveDialog) {
                Button("Remove", role: .destructive) {
                    activity.delete(from: modelContext)
                    dismiss()
                }
            }
            .onAppear {
                if isCreating {
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.hour, .minute], from: .now)
                    let date = calendar.date(byAdding: components, to: calendar.startOfDay(for: date))!
                    activity.refDeadline = date
                    activity.refEnd = date + 3600
                }
            }
        }
    }
}

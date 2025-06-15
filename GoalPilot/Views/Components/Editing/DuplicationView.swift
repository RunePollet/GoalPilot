//
//  DuplicationView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 15/04/2025.
//

import SwiftUI

/// A view that lets the user duplicate the given object on different weekdays.
struct DuplicationView<T: Duplicatable & RecurringPlanningEvent & NotificationRepresentable>: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var object: T
    var objectDisplayName: String
    
    @State private var selectedDays: [Int]
    @State private var showAlert = false
    
    init(object: T, objectDisplayName: String) {
        self.object = object
        self.objectDisplayName = objectDisplayName
        self.selectedDays = [object.weekday]
    }
    
    var body: some View {
        List {
            // Days to duplicate on
            Section {
                ForEach(1..<8) { day in
                    Button {
                        // Select or deselect this value
                        if let index = selectedDays.firstIndex(of: day) {
                            selectedDays.remove(at: index)
                        } else {
                            selectedDays.append(day)
                        }
                    } label: {
                        HStack(spacing: 5) {
                            Text(day.weekdayDescription?.capitalized ?? "Oops... I guess this day doesn't exist")
                            
                            Spacer()
                            
                            if selectedDays.contains(day) {
                                Image(systemName: "checkmark")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.accentColor)
                            }
                        }
                    }
                    .buttonStyle(.tappable)
                }
            } footer: {
                Text("The days to duplicate this \(objectDisplayName.lowercased()) on.")
            }
            
            // Duplicate button
            Button {
                duplicate()
            } label: {
                Text("Duplicate")
                    .frame(maxWidth: .infinity)
            }
            .disabled(selectedDays.isEmpty)
        }
        .navigationTitle("Duplicate \(objectDisplayName.capitalized)")
        .sensoryFeedback(.success, trigger: showAlert) { oldValue, newValue in
            return newValue
        }
        .alert("Duplicate Successful", isPresented: $showAlert) {
            Button("Ok") { dismiss() }
        } message: {
            Text("Duplicated an \(objectDisplayName.lowercased()) on \(selectedDays.count) \(selectedDays.count > 1 ? "days" : "day").")
        }
    }
    
    func duplicate() {
        // Duplicate the object
        for day in selectedDays {
            let duplicate = object.duplicate()
            duplicate.weekday = day
            
            // Insert the object into the model context if needed
            if let duplicate = duplicate as? any Persistentable {
                duplicate.insert(into: modelContext)
            }
        }
        
        // Notify the user
        showAlert = true
    }
}

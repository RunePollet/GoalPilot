//
//  MilestoneForm.swift
//  GoalPilot
//
//  Created by Rune Pollet on 27/07/2024.
//

import SwiftUI
import SwiftData

/// A form containing all data of a milestone.
struct MilestoneForm: View {
    @State var milestone: Milestone
    var isEditing: Bool
    var isCreating: Bool
    var delete: (() -> Void)?
    
    // View coordination
    @State private var showRemoveAlert = false
    
    // Accessibility
    @Query(Pillar.descriptor()) private var allPillars: [Pillar]
    
    // Navigation
    @State private var createPlanning = false
    
    var body: some View {
        Form {
            // Title and description
            Section {
                SmartNavigationLink(isActive: isEditing || isCreating, value: TextPropertyEditor<Milestone>.Model(root: milestone, keyPath: \.title, title: "Title")) {
                    LabeledContent("Title", value: milestone.title)
                }
                SmartNavigationLink(isActive: isEditing || isCreating, value: TextPropertyEditor<Milestone>.Model(root: milestone, keyPath: \.info.boundString, title: "Description", axis: .vertical)) {
                    LabeledContent {
                        Text(milestone.info.boundString)
                            .lineLimit(nil)
                    } label: {
                        Text("Description")
                    }

                }
            }
            .labeledContentStyle(.plain)
            
            // Pillars
            Section {
                ForEach(milestone.pillars) { pillar in
                    Text(pillar.title)
                }
                
                if isCreating || isEditing || milestone.pillars.isEmpty {
                    MultiPicker(content: allPillars, selection: $milestone.pillars, contentRow: { pillar in
                        Text(pillar.title)
                    }, label: {
                        Group {
                            if milestone.pillars.isEmpty {
                                Text("Add pillars")
                                    .drillIn(systemImage: "plus")
                            } else {
                                Image(systemName: "pencil")
                                    .foregroundStyle(Color.accentColor)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }, title: "Select pillars", subject: milestone.title != "" ? milestone.title : nil)
                }
            } header: {
                Text("Attached Pillars")
            } footer: {
                Text("Select pillars to indicate that this milestone helps reach or achieve them.")
            }
            
            // Planning
            Section("Planning") {
                SmartListItem(isButton: milestone.planning == nil, navigationValue: milestone.planning, signature: .init {
                    Image(systemName: "plus")
                        .imageScale(.small)
                        .fontWeight(.semibold)
                }, buttonAction: {
                    createPlanning = true
                }, label: {
                    Text(milestone.planning?.title ?? "Create Planning")
                })
            }
            
            // Remove button
            if isEditing && !isCreating {
                Button("Remove", role: .destructive) {
                    showRemoveAlert = true
                }
                .frame(maxWidth: .infinity)
            }
        }
        .alert("Are your sure?", isPresented: $showRemoveAlert) {
            Button("Cancel", role: .cancel) {}
            
            Button("Remove", role: .destructive) {
                delete?()
            }
        } message: {
            Text("Are you sure that you don't need to achieve this milestone? You won't be able to recover it after removal.")
        }
        .navigationDestination(for: Optional<Planning>.self) { planning in
            if let planning {
                PlanningDetailView(planning: planning)
            } else {
                ContentMissingView(
                    icon: "text.magnifyingglass",
                    title: "Missing planning",
                    info:
                        """
                        Oops... it seems like this milestone hasn't got a planning. This is not expected.
                        Please contact me so we can fix this together!
                        """
                ) {
                    if let url = URL(string: "https://goalpilot.be/contact-me/") {
                        Link("Contact me", destination: url)
                    }
                }
            }
        }
        .navigationDestination(for: TextPropertyEditor<Milestone>.Model.self) { model in
            TextPropertyEditor(model: model)
        }
        .sheet(isPresented: $createPlanning) {
            NavigationModelStack(isCreating: true) {
                CreatePlanningView(parent: milestone)
            }
        }
    }
}



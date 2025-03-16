//
//  GoalDetailView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 12/08/2024.
//

import SwiftUI
import SwiftData

struct GoalDetailView: View {
    @Environment(NavigationViewModel.self) private var navigationModel
    @Environment(Goal.self) private var goal
    
    enum Destination {
        case title, pillars, requirements
    }
    enum SheetContent: Int, Identifiable {
        case change = 1, addPillar, addRequirement, notAnymore, noMotivation, scaredOfFailure, burnoutOrTired, nobodyBelievesInMe, other
        var id: Int { self.rawValue }
    }
    
    @Query(Pillar.descriptor()) private var pillars: [Pillar]
    @Query(Requirement.descriptor()) private var requirements: [Requirement]
    @State private var isEditing = false
    @State private var showEditOptions = false
    @State private var showReasonOptions = false
    @State private var sheetContent: SheetContent?
    
    var body: some View {
        HighlightedList(isEditing: isEditing) {
            // Goal Title
            Section {
                Text(goal.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .fixedSize(horizontal: false, vertical: true)
                    .rowSeparatorHidden()
                    .applyPaddingTo(edges: isEditing ? .all : [.vertical, .trailing])
            }
            .sectionBackgroundColor(Color(uiColor: .systemGroupedBackground))
            .strokeHidden(!isEditing)
            .tintColor(Color(AssetsCatalog.goalColorID))
            .hasShadow(false)
            .editCompletion { showEditOptions = true }
            
            Section("Description") {
                Text(goal.info ?? "Add description")
                    .rowDrillIn(active: goal.info == nil) {
                        navigationModel.path.append(TextPropertyEditor<Goal>.Model.goalDescription(goal))
                    }
            }
            .editCompletion(isShowing: goal.info != nil) { navigationModel.path.append(TextPropertyEditor<Goal>.Model.goalDescription(goal)) }
            
            Section("Pillars") {
                if !pillars.isEmpty {
                    ForEach(pillars) {
                        Text($0.title)
                    }
                } else {
                    Text("Add a pillar")
                        .rowDrillIn {
                            sheetContent = .addPillar
                        }
                }
            }
            .editCompletion(isShowing: !pillars.isEmpty) { navigationModel.path.append(Destination.pillars) }
            
            Section("Requirements") {
                if !requirements.isEmpty {
                    ForEach(requirements) {
                        Text($0.title)
                    }
                } else {
                    Text("Add a requirement")
                        .rowDrillIn {
                            sheetContent = .addRequirement
                        }
                }
            }
            .editCompletion(isShowing: !requirements.isEmpty) { navigationModel.path.append(Destination.requirements) }
            
            Section("Chosen Way") {
                Text(goal.chosenWay)
            }
            .editCompletion { navigationModel.path.append(TextPropertyEditor<Goal>.Model(root: goal, keyPath: \.chosenWay, title: "Chosen Way", axis: .vertical, highlightColor: .accentColor)) }
            
            Section("Path Summary") {
                Text(goal.pathSummary ?? "Add your path summary")
                    .rowDrillIn(active: goal.pathSummary == nil) {
                        navigationModel.path.append(TextPropertyEditor<Goal>.Model.pathSummary(goal))
                    }
            }
            .editCompletion(isShowing: goal.pathSummary != nil) { navigationModel.path.append(TextPropertyEditor<Goal>.Model.pathSummary(goal)) }
        }
        .navigationTitle("My Goal")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(isEditing)
        .navigationDestination(for: Destination.self) { destination in
            self.destination(destination)
        }
        .sheet(item: $sheetContent){ sheetContent in
            sheet(sheetContent)
        }
        .confirmationDialog("What do you want to do?", isPresented: $showEditOptions, titleVisibility: .visible) {
            NavigationLink("Edit Title", value: Destination.title)
            
            Button("Change my goal") { sheetContent = .change }
            
            Button("I don't want to achieve my goal anymore") { sheetContent = .notAnymore }
            
            Button("Give up", role: .destructive) { showReasonOptions = true }
        }
        .confirmationDialog("Why do you want to give up?", isPresented: $showReasonOptions, titleVisibility: .visible) {
            Button("No motivation") { sheetContent = .noMotivation }
            
            Button("Scared of failure") { sheetContent = .scaredOfFailure }
            
            Button("Burn-out or tired") { sheetContent = .burnoutOrTired }
            
            Button("Nobody believes in me") { sheetContent = .nobodyBelievesInMe }
            
            Button("Other") { sheetContent = .other }
        }
        .editToolbar(isEditing: $isEditing)
    }
    
    @ViewBuilder
    private func destination(_ destination: Self.Destination) -> some View {
        switch destination {
        case .title:
            GoalTitleEditView()
        case .pillars:
            PillarSettings()
        case .requirements:
            RequirementSettings()
        }
    }
    
    private func sheet(_ sheet: SheetContent) -> some View {
        NavigationModelStack(isCreating: sheet == .addPillar || sheet == .addRequirement) {
            Group {
                switch sheet {
                case .change:
                    ChangeGoalView()
                case .addPillar:
                    CreatePillarView()
                case .addRequirement:
                    CreateRequirement()
                case .notAnymore:
                    NotAchieveAnymoreView()
                case .noMotivation:
                    NoMotivationView()
                case .scaredOfFailure:
                    ScaredOfFailureView()
                case .burnoutOrTired:
                    TiredView()
                case .nobodyBelievesInMe:
                    NobodyBelievesInMeView()
                case .other:
                    OtherView()
                }
            }
        }
    }
}

/// Represents the GoalDetailView destination in a NavigationPath.
struct GoalDetailDestination: Hashable {}

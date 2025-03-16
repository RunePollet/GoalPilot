//
//  PillarSettings.swift
//  GoalPilot
//
//  Created by Rune Pollet on 12/08/2024.
//

import SwiftUI
import SwiftData

/// List of all pillars to edit.
struct PillarSettings: View {
    @Environment(NavigationViewModel.self) private var navigationModel
    
    @Query(Pillar.descriptor()) private var pillars: [Pillar]
    @State private var createPillar = false
    
    var body: some View {
        @Bindable var navigationModel = navigationModel
        
        SettingsList(title: "Pillars", missingItemsTitle: "Missing pillars", createNewTitle: "Create pillar", items: pillars, rowTitle: { $0.title }, destination: { pillar in
            PillarForm(pillar: pillar, isEditing: true, isCreating: false)
                .navigationTitle(pillar.title)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
                .toolbar { DoneToolbarItems() }
        }, createDestination: {
            NavigationModelStack(isCreating: true) {
                CreatePillarView()
            }
        })
        .onAppear {
            navigationModel.isEditing = true
        }
    }
}

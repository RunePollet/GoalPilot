//
//  PillarsDetailView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 12/08/2024.
//

import SwiftUI
import SwiftData

/// Shows details about a pillar and lets the user edit them.
struct PillarsDetailView: View {
    @Environment(NavigationViewModel.self) private var navigationModel
    
    enum Destination { case settings }
    
    @Query(Pillar.descriptor()) private var pillars: [Pillar]
    @State private var selected: Pillar
    @State private var createPillar = false
    
    init(selected: Pillar) {
        self.selected = selected
    }
    
    var body: some View {
        
        TabView(selection: $selected) {
            ForEach(pillars) { pillar in
                PillarTile(pillar: pillar, enlarged: true)
                    .tag(pillar)
                    .padding()
                    .padding(.top)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Pillars")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbar }
        .navigationDestination(for: Destination.self) { _ in
            PillarSettings()
        }
        .sheet(isPresented: $createPillar) {
            NavigationModelStack(isCreating: true) {
                CreatePillarView { newPillar in
                    selected = newPillar
                }
            }
        }
        .onAppear {
            navigationModel.isEditing = false
        }
    }
    
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Button {
                createPillar = true
            } label: {
                Image(systemName: "plus")
            }
            
            NavigationLink(value: Destination.settings) {
                Image(systemName: "gear")
            }
        }
    }
}


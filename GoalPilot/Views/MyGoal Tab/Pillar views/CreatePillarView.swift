//
//  CreatePillarView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 12/08/2024.
//

import SwiftUI

/// Creates a pillar.
struct CreatePillarView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Goal.self) private var goal
    
    var saveCompletion: ((Pillar) -> Void)?
    
    @State private var pillar: Pillar = Pillar()
    
    var body: some View {
        PillarForm(pillar: pillar, isEditing: false, isCreating: true)
            .navigationTitle("Add Pillar")
            .navigationBarTitleDisplayMode(.inline)
            .modelInserter(model: pillar, delay: 0.5, insertCompletion: {
                pillar.parent = goal
            }, doneCompletion: { saveCompletion?(pillar) })
    }
}

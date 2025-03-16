//
//  GoalTitleEditView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 16/08/2024.
//

import SwiftUI

struct GoalTitleEditView: View {
    @Environment(Goal.self) private var goal
    
    @FocusState private var focused: Bool
    
    var body: some View {
        @Bindable var goal = goal
        
        TextField("Goal title", text: $goal.title)
            .focused($focused)
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(AssetsCatalog.goalColorID), lineWidth: 1.0)
            }
            .padding(.horizontal)
            .navigationTitle("Goal Title")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                DoneToolbarItems(disableDone: goal.title.isEmpty)
            }
            .onAppear {
                focused = true
            }
    }
}

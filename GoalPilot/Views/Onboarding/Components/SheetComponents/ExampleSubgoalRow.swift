//
//  ExampleMilestoneRow.swift
//  GoalPilot
//
//  Created by Rune Pollet on 14/05/2024.
//

import SwiftUI

/// The default row layout to represent a milestone without functionality.
struct ExampleMilestoneRow: View {
    var orderIndex: Int
    var text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Text(String(orderIndex))
                .font(.milestoneOrderIndex(size: 23))
                .fontWeight(.semibold)
                .foregroundStyle(Color(AssetsCatalog.tertiarySolidColorID))
                .padding(.top, 3)
            
            Spacer()
            
            ExampleRow(text: text)
                .background(MaterialBackground())
        }
    }
}


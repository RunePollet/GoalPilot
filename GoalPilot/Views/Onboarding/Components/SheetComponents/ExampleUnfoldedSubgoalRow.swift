//
//  ExampleUnfoldedMilestoneRow.swift
//  GoalPilot
//
//  Created by Rune Pollet on 14/05/2024.
//

import SwiftUI

/// The default row layout to represent a milestone in unfolded state without functionality.
struct ExampleUnfoldedMilestoneRow: View {
    var orderIndex: Int
    var title: String
    var info: String
    var attributes: [String]?
    var noneSelectedTitle: String?
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Text(String(orderIndex))
                .font(.milestoneOrderIndex(size: 23))
                .fontWeight(.semibold)
                .foregroundStyle(Color(AssetsCatalog.tertiarySolidColorID))
                .padding(.top, 3)
            
            Spacer()
            
            ExampleUnfoldedRow(title: title, info: info, attributes: attributes, noneSelectedTitle: noneSelectedTitle)
                .background(MaterialBackground())
        }
    }
}

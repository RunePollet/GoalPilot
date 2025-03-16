//
//  ExampleUnfoldedRow.swift
//  GoalPilot
//
//  Created by Rune Pollet on 01/05/2024.
//

import SwiftUI

/// The default row layout in unfolded state without functionality.
struct ExampleUnfoldedRow: View {
    var title: String
    var info: String
    var attributes: [String]?
    var noneSelectedTitle: String?
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.secondary)
                .fontWeight(.semibold)
                .imageScale(.small)
                .rotationEffect(.degrees(90))
                .padding(.top, 6)
            
            VStack(alignment: .leading, spacing: 7) {
                Text(title)
                
                Divider()
                
                Text(info)
                
                if let attributes {
                    Divider()
                    
                    attributesList(attributes)
                        .frame(height: 30)
                }
            }
        }
        .foregroundStyle(Color.secondary)
        .multilineTextAlignment(.leading)
        .padding(style: .textField)
        .background(MaterialBackground())
    }
    
    private func attributesList(_ attributes: [String]) -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 14) {
                if attributes.isEmpty, let noneSelectedTitle {
                    Text(noneSelectedTitle)
                        .foregroundStyle(Color.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                else {
                    ForEach(attributes, id: \.self) { attribute in
                        Text(attribute)
                            .font(.system(size: 12, weight: .bold))
                            .padding(.horizontal, 7)
                            .padding(.vertical, 5)
                            .background {
                                Capsule()
                                    .foregroundStyle(Color.accentColor)
                            }
                            .limitFrame(maxWidth: 90)
                    }
                }
            }
        }
        .contentMargins(.vertical, 5, for: .scrollContent)
        .contentMargins(.horizontal, 7, for: .scrollContent)
        .scrollIndicators(.hidden)
    }
    
}

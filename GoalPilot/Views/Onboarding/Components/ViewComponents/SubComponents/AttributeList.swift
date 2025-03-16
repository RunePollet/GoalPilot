//
//  AttributeList.swift
//  GoalPilot
//
//  Created by Rune Pollet on 01/04/2024.
//

import SwiftUI

/// The list of attributes in an item row.
struct AttributeList<Attribute>: View {
    var attributes: [Attribute]?
    var titleKeyPath: KeyPath<Attribute, String>
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 5) {
                    if let attributes {
                        ForEach(Array(attributes.enumerated()), id: \.offset) { i, attribute in
                            Text(attribute[keyPath: titleKeyPath])
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
            .scrollIndicators(.hidden)
        }
        .frame(height: 30)
    }
}


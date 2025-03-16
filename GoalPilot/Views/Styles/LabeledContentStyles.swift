//
//  LabeledContentStyles.swift
//  GoalPilot
//
//  Created by Rune Pollet on 01/08/2024.
//

import SwiftUI

struct PlainLabeledContentStyle: LabeledContentStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .foregroundStyle(Color.primary)
            Spacer()
            configuration.content
                .foregroundStyle(Color.secondary)
        }
        .lineLimit(1)
    }
}

extension LabeledContentStyle where Self == PlainLabeledContentStyle {
    static var plain: PlainLabeledContentStyle { .init() }
}


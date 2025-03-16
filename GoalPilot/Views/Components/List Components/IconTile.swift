//
//  IconTile.swift
//  GoalPilot
//
//  Created by Rune Pollet on 01/01/2025.
//

import SwiftUI

struct IconTile: View {
    var icon: String
    var sizeFactor: CGFloat
    var stretchHorizontally: Bool = true
    var stretchVertically: Bool = true
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(Color.accentColor)
                .frame(width: pct(sizeFactor, of: .width), height: pct(sizeFactor, of: .height))
                .frame(maxWidth: stretchHorizontally ? .infinity : nil, maxHeight: stretchVertically ? .infinity : nil)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color(uiColor: .secondarySystemGroupedBackground))
                        .tileShadow()
                )
        }
    }
}

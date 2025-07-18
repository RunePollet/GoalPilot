//
//  ContentMissingView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 01/01/2025.
//

import SwiftUI

/// An application of the ContentUnavailableView.
struct ContentMissingView<Content: View>: View {
    var icon: String
    var title: String
    var info: String
    @ViewBuilder var actions: Content
    
    var body: some View {
        ContentUnavailableView {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 65)
                .foregroundStyle(Color.accentColor, Color.accentColor.secondary)
                .padding()
        } description: {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
            Text(info)
        } actions: {
            HStack {
                actions
            }
            .foregroundStyle(.background)
            .font(.subheadline)
            .fontWeight(.semibold)
            .buttonStyle(.borderedProminent)
        }
    }
}

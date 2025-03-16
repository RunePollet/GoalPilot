//
//  ListView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 04/11/2024.
//

import SwiftUI

/// A list designed for the onboarding sequence that takes an input view in account.
struct ListView<Input: View, ListItem: Identifiable, ListRow: View>: View {
    var focusedField: DualTextField.Field?
    @ViewBuilder var inputView: Input
    var listContent: [ListItem]
    var listRow: (ListItem) -> ListRow
    
    @State private var refInputHeight: CGFloat = 0
    @State private var curInputHeight: CGFloat = 0
    @State private var animateListOffset = false
    
    var body: some View {
        ZStack(alignment: .top) {
            list
                .offset(y: curInputHeight - refInputHeight)
                .animation(animateListOffset ? .easeInOut : nil, value: curInputHeight)
                .onChange(of: focusedField) { oldValue, newValue in
                    animateListOffset = oldValue != nil || newValue != nil
                }
            
            inputView
                .readFrame(initialOnly: true) { frame in
                    refInputHeight = frame.height
                }
                .readFrame { frame in
                    curInputHeight = frame.height
                }
        }
    }
    
    private var list: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                Rectangle()
                    .foregroundStyle(.clear)
                    .frame(height: refInputHeight)
                
                ForEach(listContent) { listItem in
                    listRow(listItem)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

//
//  BoolToItem.swift
//  GoalPilot
//
//  Created by Rune Pollet on 27/07/2024.
//

import SwiftUI

/// Converts a boolean show indicator to a value or nil based show indicator.
struct BoolToItem<Item: Equatable, Content: View>: View {
    @Binding var selected: Item?
    var item: Item
    @ViewBuilder var view: (_ binding: Binding<Bool>) -> Content
    
    @State private var binding: Bool = false
    
    var body: some View {
        view($binding)
            .onChange(of: selected, initial: true) {
                binding = selected != nil
            }
            .onChange(of: binding) {
                selected = binding ? item : nil
            }
    }
}

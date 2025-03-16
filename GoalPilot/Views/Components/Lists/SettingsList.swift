//
//  SettingsList.swift
//  GoalPilot
//
//  Created by Rune Pollet on 01/01/2025.
//

import SwiftUI

struct SettingsList<Item: Hashable & Identifiable, Destination: View, CreateDestination: View>: View {
    var title: String
    var missingItemsTitle: String
    var createNewTitle: String
    var items: [Item]
    var rowTitle: (Item) -> String
    @ViewBuilder var destination: (Item) -> Destination
    @ViewBuilder var createDestination: CreateDestination
    
    @State private var create = false
    
    var body: some View {
        Group {
            if !items.isEmpty {
                Form {
                    ForEach(items) { item in
                        NavigationLink(value: item) {
                            Text(rowTitle(item))
                        }
                        .foregroundStyle(.primary, Color.accentColor)
                    }
                }
            } else {
                ContentMissingView(icon: "sparkle.magnifyingglass", title: missingItemsTitle, info: "Please create one to view it here.") {
                    Button(createNewTitle) {
                        create = true
                    }
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .editToolbar(showEditButton: false, showAddButton: true) {
            create = true
        }
        .navigationDestination(for: Item.self) { item in
            destination(item)
        }
        .sheet(isPresented: $create) {
            createDestination
        }
    }
}


//
//  CustomList.swift
//  GoalPilot
//
//  Created by Rune Pollet on 17/09/2024.
//

import SwiftUI

/// A list with higlighted sections.
struct HighlightedList<Content: View>: View {
    var isEditing: Bool = false
    @ViewBuilder var content: Content
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 18) {
                ForEach(sections: content) { section in
                    HighlightedSection(configuration: section, isEditing: isEditing)
                }
            }
        }
        .contentMargins(.bottom, 20, for: .scrollContent)
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

struct HighlightedSection: View {
    var configuration: SectionConfiguration
    var isEditing: Bool
    
    private var values: ContainerValues { configuration.containerValues }
    
    var body: some View {
        VStack(alignment: .leading) {
            // Header
            if !configuration.header.isEmpty {
                configuration.header
                    .foregroundStyle(.secondary)
                    .font(.system(size: 15, weight: .regular, design: .default))
                    .padding(.leading, style: .itemRow)
            }
            
            // Section
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(configuration.content.enumerated()), id: \.offset) { element in
                    let subview = element.element
                    let index = element.offset
                    let values = subview.containerValues
                    
                    subview
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .drillIn(active: values.drillIn != nil, color: self.values.tintColor) {
                            values.drillIn?()
                        }
                        .padding(values.edgesWithPadding, style: .itemRow)
                    if !values.isRowSeparatorHidden && index != configuration.content.count-1 {
                        Divider()
                            .padding(.horizontal, 10)
                    }
                }
            }
            .background(
                values.sectionBackgroundColor
                    .clipShape(ListRowBackground().shape())
                    .tileShadow(hidden: !values.hasShadow)
            )
            .highlightStroke(color: values.tintColor, hidden: values.isStrokeHidden)
            .editable(isEditing: isEditing && values.showEditButton, color: values.tintColor) {
                values.editCompletion?()
            }
            
            // Footer
            if !configuration.footer.isEmpty {
                configuration.footer
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                    .padding(.leading, style: .itemRow)
            }
        }
        .padding(.horizontal, style: .itemRow)
    }
    
}

// Container values
extension ContainerValues {
    @Entry var tintColor: Color = .accentColor
    @Entry var edgesWithPadding: Edge.Set = .all
    @Entry var sectionBackgroundColor: Color = Color(uiColor: .secondarySystemGroupedBackground)
    @Entry var isStrokeHidden: Bool = false
    @Entry var isRowSeparatorHidden: Bool = false
    @Entry var drillIn: (() -> Void)? = nil
    @Entry var editCompletion: (() -> Void)? = nil
    @Entry var isStyled: Bool = true
    @Entry var hasShadow: Bool = true
    @Entry var showEditButton: Bool = true
}

extension View {
    /// Sets the tint color of this row.
    func tintColor(_ tint: Color) -> some View {
        containerValue(\.tintColor, tint)
    }
    
    /// Applies padding to the given edges.
    func applyPaddingTo(edges: Edge.Set) -> some View {
        containerValue(\.edgesWithPadding, edges)
    }
    
    /// Sets the background of this section.
    func sectionBackgroundColor(_ color: Color = Color(uiColor: .secondarySystemGroupedBackground)) -> some View {
        containerValue(\.sectionBackgroundColor, color)
    }
    
    /// Whether the stroke of this section should be hidden.
    func strokeHidden(_ isStrokeHidden: Bool = true) -> some View {
        containerValue(\.isStrokeHidden, isStrokeHidden)
    }
    
    /// Whether the stroke of this section should be hidden.
    func rowSeparatorHidden(_ isRowSeparatorHidden: Bool = true) -> some View {
        containerValue(\.isRowSeparatorHidden, isRowSeparatorHidden)
    }
    
    /// Provides a drill in action for this row.
    func rowDrillIn(active: Bool = true, _ completion: @escaping () -> Void) -> some View {
        containerValue(\.drillIn, active ? completion : nil)
    }
    
    /// Provides an edit completion for this section.
    func editCompletion(isShowing: Bool = true, _ completion: @escaping () -> Void) -> some View {
        self
            .containerValue(\.editCompletion, completion)
            .containerValue(\.showEditButton, isShowing)
    }
    
    /// Keeps this view from being styled by the HighlightedList container.
    func plain() -> some View {
        self
            .containerValue(\.isStyled, false)
            .containerValue(\.hasShadow, false)
    }
    
    /// Whether the section should have a shadow.
    func hasShadow(_ hasShadow: Bool) -> some View {
        containerValue(\.hasShadow, hasShadow)
    }
}

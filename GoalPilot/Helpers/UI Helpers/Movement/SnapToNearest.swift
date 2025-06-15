//
//  SnapToNearest.swift
//  GoalPilot
//
//  Created by Rune Pollet on 05/02/2025.
//

import SwiftUI

struct SnapToNearestViewModifier: ViewModifier {
    @Binding var scrollPosition: ScrollPosition
    var snapCompletion: ((any Hashable & Sendable) -> Void)?
    
    // View Coordination
    @State private var timeSinceLastUpdate: Date?
    @State private var snappingEnabled: Bool = true
    @State private var axis: Axis
    
    init(scrollPosition: Binding<ScrollPosition>, axis: Axis, snapCompletion: ((any Hashable & Sendable) -> Void)? = nil) {
        self._scrollPosition = scrollPosition
        self.snapCompletion = snapCompletion
        self.axis = axis
    }
    
    func body(content: Content) -> some View {
        content
            .onScrollGeometryChange(for: CGFloat.self, of: { geo in
                return axis == .horizontal ? geo.contentOffset.x : geo.contentOffset.y
            }, action: { oldValue, newValue in
                // Only set the time since last update if this is the first update of the scroll
                guard let timeSinceLastUpdate, snappingEnabled else {
                    self.timeSinceLastUpdate = .now
                    return
                }
                
                // Calculate the current velocity
                let translation = abs(oldValue - newValue)
                let timeInterval = Date.now.timeIntervalSince(timeSinceLastUpdate)
                let velocity = translation/timeInterval
                
                // Snap to the nearest item if the velocity is low enough
                if velocity < 15 {
                    snapToNearestItem()
                    self.timeSinceLastUpdate = nil
                    snappingEnabled = false
                } else {
                    self.timeSinceLastUpdate = .now
                }
            })
            .onScrollPhaseChange { oldPhase, newPhase, context in
                // Determine if we can snap the scroll view
                if oldPhase == .interacting && newPhase == .idle {
                    snapToNearestItem()
                } else {
                    snappingEnabled = newPhase == .decelerating
                }
            }
    }
    
    func snapToNearestItem() {
        if let id = scrollPosition.viewID {
            withAnimation {
                scrollPosition.scrollTo(id: id, anchor: .center)
            }
            snapCompletion?(id)
        }
    }
}

extension ScrollView {
    /// Snaps the nearest view element of the scroll view to the anchor set by the scroll position.
    @MainActor
    func snapToNearestView(scrollPosition: Binding<ScrollPosition>, axis: Axis = .vertical, snapCompletion: ((any Hashable & Sendable) -> Void)? = nil) -> some View {
        modifier(SnapToNearestViewModifier(scrollPosition: scrollPosition, axis: axis, snapCompletion: snapCompletion))
    }
}

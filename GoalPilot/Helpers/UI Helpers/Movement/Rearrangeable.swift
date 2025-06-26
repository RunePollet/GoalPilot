//
//  Rearrangeable.swift
//  GoalPilot
//
//  Created by M&M Pollet-Cauwels on 29/05/2024.
//

import SwiftUI

// MARK: - Drag Reader

private struct DragReader: ViewModifier {
    @Environment(\.currentDragPosition) private var currentDragPosition: CGPoint?
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    var parentID: String
    var onStarted: () -> Void
    var isTargeted: () -> Void
    var onEnded: () -> Void
    
    @State private var offset: CGSize? = nil
    @State private var isDragging = false
    
    func body(content: Content) -> some View {
        let dragGesture = DragGesture()
            .onChanged { value in
                if isEnabled {
                    update(value.translation)
                }
            }
            .onEnded { _ in
                if isEnabled {
                    end()
                }
            }
        
        let longPressGesture = LongPressGesture(minimumDuration: 0.5, maximumDistance: 50)
            .onEnded { _ in
                if isEnabled {
                    start()
                }
            }
        
        let tapGesture = TapGesture()
            .onEnded { _ in
                if isEnabled {
                    end()
                }
            }
        
        let combinedGesture = SequenceGesture(longPressGesture, dragGesture.simultaneously(with: tapGesture))
        
        content
            .anchorPreference(key: AnchorPreference.self, value: .bounds, transform: { anchor in
                if isDragging {
                    return [Keys.anchorKey(parentID): anchor]
                } else {
                    return ["": nil]
                }
            })
            .preference(key: OffsetPreference.self, value: isDragging ? [Keys.offsetKey(parentID): offset] : ["": nil])
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onChange(of: currentDragPosition) {
                            if let currentDragPosition {
                                let frame = geo.frame(in: .named(Keys.referenceCoordinateSpace(parentID)))
                                var isTargeted: Bool {
                                    let x = frame.minX <= currentDragPosition.x && currentDragPosition.x <= frame.maxX
                                    let y = frame.minY <= currentDragPosition.y && currentDragPosition.y <= frame.maxY
                                    return x && y
                                }
                                
                                if isTargeted {
                                    self.isTargeted()
                                }
                            }
                        }
                }
            )
            .simultaneousGesture(combinedGesture)
    }
    
    func start() {
        isDragging = true
        onStarted()
    }
    
    func update(_ translation: CGSize) {
        offset = translation
    }
    
    func end() {
        isDragging = false
        offset = .zero
        onEnded()
    }
}

// Preference key for the anchor of the content
private struct AnchorPreference: PreferenceKey {
    static let defaultValue: [String: Anchor<CGRect>?] = [:]
    static func reduce(value: inout [String: Anchor<CGRect>?], nextValue: () -> [String: Anchor<CGRect>?]) {
        for (key, anchor) in nextValue() {
            value[key] = anchor
        }
    }
}

// Preference key for the offset
private struct OffsetPreference: PreferenceKey {
    static let defaultValue: [String: CGSize?] = [:]
    static func reduce(value: inout [String : CGSize?], nextValue: () -> [String : CGSize?]) {
        for (key, offset) in nextValue() {
            value[key] = offset
        }
    }
}

extension View {
    /// Reads the location of this view in the reference coordinate space indicated by the `rearrangeable` modifier, makes it draggable and indicates when it is targeted by another view which is being dragged.
    func rearrange(parentID: String = "DEFAULT_KEY", onStarted: @escaping () -> Void, isTargeted: @escaping () -> Void, onEnded: @escaping () -> Void) -> some View {
        self.modifier(DragReader(parentID: parentID, onStarted: onStarted, isTargeted: isTargeted, onEnded: onEnded))
    }
}


// MARK: - Information Distributor

private struct DragInformationDistributor: ViewModifier, Identifiable {
    var id: String
    var isEnabled: Bool
    
    @State private var anchor: Anchor<CGRect>? = nil
    @State private var offset: CGSize? = nil
    @State private var startPosition: CGRect? = nil
    @State private var currentDragPosition: CGPoint?
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onChange(of: anchor) {
                            if let anchor {
                                self.startPosition = geo[anchor]
                            }
                        }
                }
            )
            .onPreferenceChange(AnchorPreference.self, perform: { value in
                Task {
                    await MainActor.run {
                        anchor = value[Keys.anchorKey(id)] ?? nil
                    }
                }
            })
            .onPreferenceChange(OffsetPreference.self, perform: { value in
                Task {
                    await MainActor.run {
                        offset = value[Keys.offsetKey(id)] ?? nil
                    }
                }
            })
            .onChange(of: offset) {
                calculateCurrentDragPosition()
            }
            .environment(\.currentDragPosition, currentDragPosition)
            .environment(\.isEnabled, isEnabled)
            .coordinateSpace(.named(Keys.referenceCoordinateSpace(id)))
    }
    
    func calculateCurrentDragPosition() {
        if let offset, let startPosition {
            let curPos = CGPoint(x: startPosition.midX + offset.width, y: startPosition.midY + offset.height)
            currentDragPosition = curPos
        } else {
            currentDragPosition = nil
        }
    }
}

private extension EnvironmentValues {
    @Entry var isEnabled: Bool = true
    @Entry var currentDragPosition: CGPoint? = nil
}

extension View {
    /// Indicates that child views of this view can be rearranged using the `rearrange` modifier.
    func rearrangeable(_ isEnabled: Bool = true, id: String = "DEFAULT_KEY") -> some View {
        self.modifier(DragInformationDistributor(id: id, isEnabled: isEnabled))
    }
}


// MARK: - Keys

private final class Keys {
    static func anchorKey(_ ID: String) -> String { "ANCHOR-\(ID)" }
    static func offsetKey(_ ID: String) -> String { "OFFSET-\(ID)" }
    static func referenceCoordinateSpace(_ ID: String) -> String { "REFERENCE_COORDINATE_SPACE-\(ID)" }
}

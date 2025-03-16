//
//  ReadRect.swift
//  GoalPilot
//
//  Created by Rune Pollet on 30/03/2024.
//

import SwiftUI

struct ReadFrame: ViewModifier {
    var coordinateSpace: CoordinateSpace
    var initialOnly: Bool
    var active: Bool
    var completion: (CGRect) -> Void
    
    func body(content: Content) -> some View {
        content
            .background {
                if active {
                    GeometryReader { geo in
                        Rectangle()
                            .foregroundStyle(Color.clear)
                            .onAppear {
                                completion(geo.frame(in: coordinateSpace))
                            }
                            .onChange(of: geo.frame(in: coordinateSpace)) {
                                if !initialOnly {
                                    completion(geo.frame(in: coordinateSpace))
                                }
                            }
                    }
                }
            }
    }
}

extension View {
    func readFrame(space: CoordinateSpace = .global, initialOnly: Bool = false, active: Bool = true, _ completion: @escaping (CGRect) -> Void) -> some View {
        self.modifier(ReadFrame(coordinateSpace: space, initialOnly: initialOnly, active: active, completion: completion))
    }
}

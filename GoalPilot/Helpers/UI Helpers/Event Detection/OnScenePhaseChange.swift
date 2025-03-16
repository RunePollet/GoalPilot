//
//  OnScenePhaseChange.swift
//  GoalPilot
//
//  Created by Rune Pollet on 22/08/2024.
//

import SwiftUI

struct OnScenePhaseChangeModifier: ViewModifier {
    @Environment(\.scenePhase) private var scenePhase
    
    var scene: ScenePhase
    var completion: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onChange(of: scenePhase) { oldValue, newValue in
                if newValue == scene {
                    completion()
                }
            }
    }
}

extension View {
    func onScenePhaseChange(to scene: ScenePhase, _ completion: @escaping () -> Void) -> some View {
        modifier(OnScenePhaseChangeModifier(scene: scene, completion: completion))
    }
}

//
//  StarPowerupView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 07/01/2024.
//

import SwiftUI

/// An interactive animation that uses star particles to symbolize a growing star.
struct StarPowerupView: View {
    var handler: StarPowerupHandler
    
    // Impact feedback
    @State private var rigidFeedback = false
    @State private var successFeedback = false
    
    var body: some View {
        ZStack {
            mainStarShadow
                .transition(.opacity)
            
            StarFigure.StarParticles(target: .center, particleSize: .init(width: 20, height: 20), particleShape: StarFigure.StarShape()) { date in
                return handler.spawnStar(date)
            } color: { date in
                return handler.getColor(date: date)
            } killCompletion: {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }
            
            if handler.showPressingIndicator {
                pressingIndicator
                    .transition(
                        AnyTransition.asymmetric(
                            insertion: .opacity,
                            removal: .opacity.animation(.easeInOut(duration: 0.8))
                        )
                    )
            }
            
            mainStar
            
            // Press Plate
            if !handler.mainStarPop {
                Button {
                    handler.stopPowerupAnimation()
                } label: {
                    Color.primary.opacity(0.001)
                }
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.0)
                        .onEnded { _ in
                            handler.startPowerupAnimation()
                        }
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sensoryFeedback(.impact(flexibility: .rigid), trigger: rigidFeedback)
        .sensoryFeedback(.success, trigger: successFeedback)
        .ignoresSafeArea()
    }
    
    private var pressingIndicator: some View {
        struct AnimationValues {
            var width: Double = 40
            var opacity: Double = 0
        }
        
        return ZStack {
            Circle()
                .stroke(handler.color, lineWidth: 5)
                .frame(width: 40)
            
            Circle()
                .stroke(handler.color, lineWidth: 2)
                .keyframeAnimator(initialValue: AnimationValues()) { content, value in
                    content
                        .frame(width: value.width)
                        .opacity(value.opacity)
                } keyframes: { _ in
                    KeyframeTrack(\.width) {
                        LinearKeyframe(45, duration: 0.4)
                        CubicKeyframe(70, duration: 1.5)
                        LinearKeyframe(70, duration: 0.4)
                    }
                    KeyframeTrack(\.opacity) {
                        LinearKeyframe(0, duration: 0.1)
                        CubicKeyframe(0.7, duration: 0.3)
                        LinearKeyframe(0.7, duration: 0.6)
                        LinearKeyframe(1, duration: 0.1)
                        LinearKeyframe(1, duration: 0.1)
                        LinearKeyframe(0.7, duration: 0.3)
                        LinearKeyframe(0.7, duration: 0.3)
                        LinearKeyframe(0, duration: 0.5)
                    }
                }
        }
    }
    
    private var mainStar: some View {
        let leftEye = StarFigure.Eye(
            side: .left,
            frame: (30/300, 45/300), pupilFrame: (9.14/20.2, 10.73/29.18),
            opacity: 0)
        let leftEyebrow = StarFigure.Eyebrow(
            side: .left,
            frame: (40/300, 20/300),
            rotation: .degrees(-15),
            offset: (3/300, -40/300),
            scaleAnchor: .trailing,
            opacity: 0)
        let rightEye = StarFigure.Eye(
            side: .right,
            closed: true,
            frame: (30/300, 45/300), pupilFrame: (9.14/20.2, 10.73/29.18),
            opacity: 0,
            closedOpacity: 0)
        let rightEyebrow = StarFigure.Eyebrow(
            side: .right,
            frame: (40/300, 20/300),
            rotation: .degrees(15),
            offset: (-3/300, -40/300),
            scaleAnchor: .leading,
            opacity: 0)
        let mouth = StarFigure.Mouth(frame: (70/300, 53.85/300), opacity: 0)
        let initialValue = StarFigure.StarViewConfiguration(
            character: handler.mainStarCharacter,
            leftEye: leftEye,
            rightEye: rightEye,
            leftEyebrow: leftEyebrow,
            rightEyebrow: rightEyebrow,
            mouth: mouth)
        
        return StarFigure.StarView()
            .keyframeAnimator(initialValue: initialValue, trigger: handler.mainStarPop) { content, value in
                StarFigure.StarView(config: value)
            } keyframes: { value in
                StarFigure.StarView.popAndWinkKeyframes(value)
            }
            .frame(width: 300, height: 300)
            .scaleEffect(handler.mainStarScale)
            .onChange(of: handler.mainStarPop) {
                // Pop feedback
                successFeedback.toggle()
                
                // Wink feedback
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                        rigidFeedback.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.44) {
                        rigidFeedback.toggle()
                    }
                }
            }
    }
    
    private var mainStarShadow: some View {
        Circle()
            .foregroundStyle((handler.secondColor ?? handler.color).opacity(0.4))
            .frame(width: 360, height: 360)
            .scaleEffect(handler.mainStarScale)
            .blur(radius: handler.mainStarShadowBlur)
    }
}

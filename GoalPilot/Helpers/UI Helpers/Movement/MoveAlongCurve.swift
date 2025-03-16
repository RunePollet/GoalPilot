//
//  MoveAlongCurve.swift
//  GoalPilot
//
//  Created by Rune Pollet on 19/05/2024.
//

import SwiftUI

/// A view which move the content along the given path by updating the progress from 0 to 1.
struct MoveAlongCurve<Content: View>: View {
    var progress: CGFloat
    @ViewBuilder var content: (Path) -> Content
    var departPosition: UnitPoint
    var destinationPosition: UnitPoint
    var pathProvider: (_ path: inout Path, _ departure: CGPoint, _ destination: CGPoint, _ size: CGSize) -> Void
    
    var body: some View {
        GeometryReader { geo in
            let availableFrame = geo.frame(in: .global)
            // Positions
            let departure: CGPoint = departPosition.getPoint(in: geo.size)
            let destination: CGPoint = destinationPosition.getPoint(in: geo.size)
            let path = Path { path in
                pathProvider(&path, departure, destination, availableFrame.size)
            }
            
            content(path)
                .modifier(
                    AnimatedPosition(departure: departure, path: path, progress: progress)
                )
        }
    }
    
}

/// Used to enable progressive updates when animating to position the content at the part of the path resembling the progress of the animation.
private struct AnimatedPosition: ViewModifier, Animatable {
    var departure: CGPoint
    var path: Path
    var progress: CGFloat
    
    nonisolated var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .position(
                path.trimmedPath(from: 0, to: progress).currentPoint ?? departure
            )
    }
}

private extension UnitPoint {
    func getPoint(in size: CGSize) -> CGPoint {
        return .init(x: x*size.width, y: y*size.height)
    }
}

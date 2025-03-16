//
//  PathSection.swift
//  GoalPilot
//
//  Created by Rune Pollet on 05/11/2024.
//

import SwiftUI

/// A list section representing a path to a milestone.
struct PathSection<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    
    enum Phase: Int {
        case todo, inProgress, completed
    }
    
    var title: String
    var starNumber: Int
    var phase: Self.Phase
    @ViewBuilder var content: Content
    
    // View coordination
    @State private var pathHeight: CGFloat = 0
    private var fontSize: CGFloat {
        return starNumber > 9 ? 14 : 18
    }
    private var dash: [CGFloat] {
        switch phase {
        case .todo:
            return [5, 10, 9, 10, 5]
        case .inProgress:
            return [5, 10, pathHeight-15]
        case .completed:
            return []
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // Title row
            HStack(alignment: .center, spacing: 15) {
                starIcon(number: starNumber, phase: phase)
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
            
            // Content row
            HStack(spacing: 15) {
                Group {
                    if phase != .todo {
                        SectionPath()
                            .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 6, lineCap: .round, dash: dash))
                    } else {
                        if colorScheme == .dark {
                            SectionPath()
                                .stroke(.gray.opacity(0.4), style: StrokeStyle(lineWidth: 6, lineCap: .round, dash: dash))
                        } else {
                            SectionPath()
                                .stroke(.ultraThinMaterial, style: StrokeStyle(lineWidth: 6, lineCap: .round, dash: dash))
                        }
                    }
                }
                .frame(width: fontSize+18)
                content
            }
            .padding(.vertical)
            .readFrame(initialOnly: true) { frame in
                pathHeight = frame.height
            }
        }
    }
    
    private func starIcon(number: Int?, phase: Self.Phase)-> some View {
        ZStack {
            StarFigure.StarShape()
                .conditional(phase == .completed) {
                    $0.foregroundStyle(Color.accentColor)
                }
                .conditional(phase != .completed) {
                    $0
                        .conditional(colorScheme == .dark) {
                            $0.foregroundStyle(.gray.opacity(0.4))
                        }
                        .conditional(colorScheme != .dark) {
                            $0.foregroundStyle(.ultraThinMaterial)
                        }
                }
            
            if let number {
                Text(String(number))
                    .font(.milestoneOrderIndexBold(size: fontSize))
                    .offset(y: 1.4)
                    .foregroundStyle(Color(AssetsCatalog.firstHillColorID))
                    .lineLimit(1)
            }
        }
        .frame(width: fontSize+18, height: fontSize+18)
        .clipShape(StarFigure.StarShape())
    }
    
    private struct SectionPath: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: .init(x: rect.width/2, y: 0))
            path.addLine(to: .init(x: rect.width/2, y: rect.height))
            return path
        }
    }
}

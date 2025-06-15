//
//  PillarTile.swift
//  GoalPilot
//
//  Created by Rune Pollet on 05/06/2024.
//

import SwiftUI
import SwiftData

/// A summary of the given pillar in a tile.
struct PillarTile: View {
    @Environment(\.modelContext) var modelContext
    
    var pillar: Pillar
    var enlarged: Bool
    
    private var milestones: [Milestone] { pillar.milestones.sorted { $0.orderIndex > $1.orderIndex } }
    @State private var proxy: GeometryProxy?
    @State private var scrollContentHeightThatFits: CGFloat = 0
    
    init(pillar: Pillar, enlarged: Bool = false) {
        self.pillar = pillar
        self.enlarged = enlarged
    }
    
    var body: some View {
        
        VStack(spacing: enlarged ? 30 : 10) {
            VStack(spacing: 10) {
                if let imageData = pillar.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .limitFrame(maxHeight: pct(100/393, of: .width))
                } else {
                    Image(systemName: pillar.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color.accentColor)
                        .frame(width: pct(55/393, of: .width))
                }
                
                Text(pillar.title)
                    .font(enlarged ? .title2 : .system(size: 15))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
            }
            
            if !milestones.isEmpty {
                Divider()
                
                milestoneSummary
            }
        }
        .padding(enlarged ? 20 : 10)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color(uiColor: .secondarySystemGroupedBackground))
                .tileShadow()
        )
    }
    
    /// A little summary of the milestones that need to be achieved for this pillar.
    private var milestoneSummary: some View {
        let heightThatFits = scrollContentHeightThatFits
        let maxHeight = enlarged ? .infinity : 171.0
        let contentMargin = 15.0
        
        return ScrollView {
            VStack(spacing: 0) {
                ForEach(milestones) { milestone in
                    milestoneRepresentation(milestone)
                }
            }
            .padding(contentMargin)
        }
        .scrollIndicators(.hidden)
        .defaultScrollAnchor(.bottom)
        .onScrollGeometryChange(for: CGFloat.self, of: { geo in
            return geo.contentSize.height
        }, action: { oldValue, newValue in
            scrollContentHeightThatFits = newValue
        })
        .background {
            RoundedRectangle(cornerRadius: 9)
                .fill(Color(AssetsCatalog.tertiaryColorID))
        }
        .frame(height: min(heightThatFits, maxHeight))
    }
    
    private func milestoneRepresentation(_ milestone: Milestone) -> some View {
        HStack(alignment: .top) {
            milestoneLine(index: milestones.firstIndex(of: milestone) ?? 0, achieved: milestone.achieved)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(milestone.title)
                    .font(enlarged ? .subheadline : .caption)
                    .fontWeight(enlarged ? .semibold : .regular)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(enlarged ? Color.primary : Color.secondary)
                
                if let info = milestone.info, enlarged {
                    Text(info)
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.secondary)
                }
            }
            
            Spacer()
        }
        .limitFrame(maxHeight: enlarged ? 107 : 57)
    }
    
    /// Indicates whether this milestone has been achieved.
    private func milestoneLine(index: Int, achieved: Bool) -> some View {
        VStack(spacing: 0) {
            if !achieved {
                RoundedRectangle(cornerRadius: 1.5)
                    .frame(width: enlarged ? 10 : 6, height: enlarged ? 4 : 2)
            } else {
                Checkmark(milestones: milestones.map({$0.achieved}), enlarged: enlarged, index: index)
            }
            
            Rectangle()
                .frame(width: enlarged ? 5 : 2)
            
            if index == milestones.count-1 {
                RoundedRectangle(cornerRadius: 1.5)
                    .frame(width: enlarged ? 10 : 6, height: enlarged ? 4 : 2)
            }
        }
        .foregroundStyle(achieved ? Color.accentColor : Color(AssetsCatalog.tertiaryOverlayColorID))
        .frame(width: enlarged ? 22 : 14)
        
    }
}

// Components
extension PillarTile {
    private struct Checkmark: View {
        var milestones: [Bool]
        var enlarged: Bool
        var index: Int
        
        @State private var checkmarkHeight: CGFloat = 0
        
        var body: some View {
            Image(systemName: "checkmark.circle.fill")
                .imageScale(enlarged ? .large : .small)
                .readFrame(initialOnly: true) { frame in
                    checkmarkHeight = frame.size.height
                }
                .background {
                    Rectangle()
                        .frame(width: enlarged ? 5 : 2, height: checkmarkHeight*0.1)
                        .foregroundStyle(milestones[index] ? Color.accentColor : Color(AssetsCatalog.tertiaryOverlayColorID))
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    if index > 0 {
                        Rectangle()
                            .frame(width: enlarged ? 5 : 2, height: checkmarkHeight*0.1)
                            .foregroundStyle(milestones[index-1] ? Color.accentColor : Color(AssetsCatalog.tertiaryOverlayColorID))
                            .frame(maxHeight: .infinity, alignment: .top)
                    }
                }
        }
    }
}

//
// ItemRow.swift
//  GoalPilot
//
//  Created by Rune Pollet on 29/03/2024.
//

import SwiftUI
import SwiftData


// MARK: - ItemRow

/// The default row layout for onboarding rows.
struct ItemRow: View {
    var title: String
    var info: String?
    var removeCompletion: () -> Void
    
    var body: some View {
        AttributesItemRow(
            mode: .standard,
            title: title,
            info: info,
            removeCompletion: removeCompletion,
            attributes: [String](),
            selectedAttributes: .constant([String]()),
            titleKeyPath: \.description,
            pickerShowing: .constant(false)
        )
    }
}


// MARK: - MilestoneItemRow

/// The default row layout to represent a milestone in onboarding.
struct MilestoneItemRow: View {
    
    @Bindable var milestone: Milestone
    @Binding var dragItem: Milestone?
    var remove: () -> Void
    
    @Query(Pillar.descriptor()) private var pillars: [Pillar]
    @State private var isPickerShowing = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Text(String(milestone.orderIndex))
                .font(.milestoneOrderIndex(size: 23))
                .foregroundStyle(Color(AssetsCatalog.tertiarySolidColorID))
                .padding(.top, 4)
                .frame(width: 15)
            
            Spacer()
            
            ZStack {
                MaterialBackground()
                    .padding(.trailing)
                    .shadow(radius: dragItem == milestone ? 5 : 0)
                    .animation(.easeInOut, value: dragItem)
                AttributesItemRow(
                    mode: .milestone,
                    title: milestone.title,
                    info: milestone.info,
                    removeCompletion: remove,
                    attributes: pillars,
                    selectedAttributes: $milestone.pillars,
                    titleKeyPath: \Pillar.title,
                    pickerTitle: "Select pillars to attach",
                    pickerFooter: "You can select a pillar to indicate that this milestone helps reach or achieve the pillar.",
                    noneSelectedTitle: "No pillars",
                    pickerShowing: $isPickerShowing
                )
                .padding(.trailing)
            }
        }
        .padding(.leading)
    }
}


// MARK: - AttributesItemRow

/// An adaptive item layout row with a list of attributes.
private struct AttributesItemRow<Attribute: Equatable>: View {
    enum Mode {
        case standard
        case milestone
    }
    
    var mode: Mode = .standard
    var title: String
    var info: String?
    var removeCompletion: () -> Void
    var attributes: [Attribute]
    @Binding var selectedAttributes: [Attribute]
    var titleKeyPath: KeyPath<Attribute, String>
    var pickerTitle: String?
    var pickerFooter: String?
    var noneSelectedTitle: String?
    @Binding var pickerShowing: Bool
    
    @State private var showInfo: Bool = false
    @State private var infoScrollViewHeight: CGFloat = 0
    @State private var titleHeight: CGFloat = 0
    private var showChevron: Bool {
        (info != nil && info != "") || mode == .milestone
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            // Show info button
            if showChevron {
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.secondary)
                    .fontWeight(.semibold)
                    .imageScale(.small)
                    .rotationEffect(showInfo ? .degrees(90) : .zero)
                    .padding(.horizontal, style: .textField)
                    .frame(height: titleHeight)
                    .onTapGesture {
                        withAnimation {
                            showInfo.toggle()
                        }
                    }
            }
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    // Title
                    Text(title)
                        .tint(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)
                        .padding(showChevron ? .vertical : [.vertical, .leading], style: .textField)
                        .readFrame(initialOnly: true) { frame in
                            titleHeight = frame.size.height
                        }
                    
                    // Delete button
                    Image(systemName: "multiply")
                        .foregroundStyle(Color.secondary)
                        .fontWeight(.semibold)
                        .imageScale(.small)
                        .padding(style: .textField)
                        .onTapGesture {
                            removeCompletion()
                        }
                    
                    // Grabber
                    if mode == .milestone {
                        Grabber()
                            .padding([.trailing, .vertical], style: .textField)
                    }
                }
                
                // Description
                if let info, showInfo {
                    infoView(info)
                }
                
                // Attribute list
                if mode == .milestone && showInfo {
                    VStack(spacing: 0) {
                        Divider()
                        
                        HStack {
                            AttributeList(attributes: selectedAttributes, titleKeyPath: titleKeyPath)
                                .background {
                                    if selectedAttributes.isEmpty, let noneSelectedTitle {
                                        Text(noneSelectedTitle)
                                            .foregroundStyle(Color.secondary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            
                            MultiPicker(
                                showing: $pickerShowing,
                                content: attributes,
                                selection: $selectedAttributes,
                                contentRow: { pillar in
                                    Text(pillar[keyPath: titleKeyPath])
                                        .foregroundStyle(Color.black)
                                },
                                label: {
                                    Image(systemName: "pencil")
                                        .foregroundStyle(Color.secondary)
                                        .fontWeight(.semibold)
                                        .imageScale(.small)
                                        .padding(style: .textField)
                                },
                                title: pickerTitle,
                                subject: title != "" ? title : nil,
                                footer: pickerFooter
                            )
                        }
                        .padding(.vertical, style: .textField)
                    }
                }
            }
        }
        .clipped()
    }
    
    private func infoView(_ info: String) -> some View {
        VStack(spacing: 0) {
            Divider()
            ScrollView {
                HStack {
                    Text(info)
                        .tint(.white)
                        .multilineTextAlignment(.leading)
                        .readFrame { frame in
                            withAnimation {
                                infoScrollViewHeight = frame.height
                            }
                        }
                    Spacer()
                }
            }
            .scrollIndicators(.hidden)
            .scrollDisabled(infoScrollViewHeight <= pct(170/852, of: .height))
            .frame(height: min(infoScrollViewHeight, pct(170/852, of: .height)))
            .padding(.vertical, style: .textField)
        }
    }
}

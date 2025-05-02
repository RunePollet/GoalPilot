//
//  ScrollSnappingTest.swift
//  GoalPilot
//
//  Created by Rune Pollet on 12/10/2024.
//

import SwiftUI

/// A horizontal scrolling day picker.

struct DayPicker: View {
    @Environment(PlannerViewModel.self) private var plannerModel

    var background: Color = Color(uiColor: .systemBackground)
    
    // View coordination
    @State private var monthPickerSize: CGSize = .zero
    @State private var pushEdge: Edge = .bottom
    
    @State private var scrollPosition: ScrollPosition = .init(idType: String.self)
    @State private var timeSinceLastUpdate: Date?
    @State private var snappingEnabled: Bool = true
    @State private var selectionFeedback = false
    
    private let screenWidth: CGFloat = { WindowService.screenSize().width }()
    private var contentMargin: CGFloat { 0.5*screenWidth-itemWidth/2 }
    private let itemWidth: CGFloat = 50
    private let itemSpacing: CGFloat = -1
    
    var body: some View {
        ZStack {
            Capsule()
                .foregroundStyle(Color("TertiaryColor"))
                .frame(width: itemWidth)
                .zIndex(0)
            
            daysScrollView
                .zIndex(1)
            
            HStack(spacing: 0) {
                MonthPicker(pushEdge: $pushEdge)
                    .padding(.leading)
                    .background(background)
                    .readFrame(initialOnly: true) { frame in
                        self.monthPickerSize = frame.size
                    }
                Divider()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .zIndex(2)
        }
        .frame(height: monthPickerSize.height)
        .clipped()
        .sensoryFeedback(.selection, trigger: selectionFeedback)
    }
    
    private var daysScrollView: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: itemSpacing) {
                ForEach(Array(plannerModel.displayedDates.enumerated()), id: \.element.dayID) { value in
                    let date = value.element
                    let index = value.offset
                    
                    DateCell(date: date, index: index, displayedDates: plannerModel.displayedDates)
                        .frame(width: itemWidth)
                        .onTapGesture {
                            // Select this date
                            withAnimation {
                                scrollPosition.scrollTo(id: date.dayID, anchor: .center)
                            }
                            plannerModel.currentDate = date
                            selectionFeedback.toggle()
                        }
                }
            }
            .scrollTargetLayout()
        }
        .snapToNearestView(scrollPosition: $scrollPosition, axis: .horizontal) { id in
            if let date = Date.getFromDayID(id as? String ?? "") {
                // Select the date
                plannerModel.currentDate = date
                selectionFeedback.toggle()
            }
        }
        .scrollIndicators(.hidden)
        .scrollPosition($scrollPosition, anchor: .center)
        .contentMargins(.horizontal, contentMargin, for: .scrollContent)
        .transition(.push(from: pushEdge))
        .id(plannerModel.displayedMonth)
        .onChange(of: plannerModel.currentDate, initial: true) {
            scrollPosition.scrollTo(id: plannerModel.currentDate.dayID, anchor: .center)
        }
    }
}

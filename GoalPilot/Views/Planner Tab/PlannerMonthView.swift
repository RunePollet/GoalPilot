//
//  PlannerMonthView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 31/10/2024.
//

import SwiftUI
import SwiftData

/// Shows the current month and its events according to the planner model.
struct PlannerMonthView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(PlannerViewModel.self) private var plannerModel
    @Environment(GlobalViewModel.self) private var globalModel
    @Environment(StreakViewModel.self) private var streakModel
    
    var planning: Planning
    
    // Accessibility
    @Query(Planning.descriptor()) private var allPlannings: [Planning]
    
    // View coordination
    @Namespace private var namespace
    @State private var pushEdge: Edge = .leading
    @State private var scrollPosition: ScrollPosition = .init(idType: String.self)
    
    private let column: GridItem = GridItem(.flexible(minimum: .zero, maximum: .infinity), spacing: 1)
    private var columnWidth: CGFloat {
        WindowService.screenSize().width/3
    }
    
    // Navigation
    @State private var navigationModel = NavigationViewModel(path: .init([Date.now]))
    
    var body: some View {
        NavigationStack(path: $navigationModel.path) {
            VStack(spacing: 0) {
                MonthPicker(horizontal: true, pushEdge: $pushEdge)
                    .padding(.horizontal)
                
                Divider()
                
                dayList
            }
            .toolbarVisibility(navigationModel.hideTabBar ? .hidden : .visible, for: .tabBar)
            .animation(.default, value: navigationModel.hideTabBar)
            .navigationTitle(plannerModel.currentPlanning?.title ?? "")
            .toolbar { toolbar }
            .navigationDestination(for: Date.self) { date in
                PlannerDayView(plannerModel: plannerModel)
                    .navigationTransition(.zoom(sourceID: plannerModel.currentDate.dayID, in: namespace))
            }
            .navigationDestination(for: Planning.self) { planning in
                PlanningDetailView(planning: planning)
                    .onAppear { navigationModel.hideTabBar = true }
            }
        }
        .environment(navigationModel)
        .onChange(of: navigationModel.path) {
            if navigationModel.path.isEmpty {
                navigationModel.hideTabBar = false
            }
        }
        .onChange(of: globalModel.resetUITrigger) { oldValue, newValue in
            navigationModel.path = .init([Date.now])
        }
        .onAppear {
            navigationModel.hideTabBar = false
            plannerModel.setCurrentPlanning(to: planning, using: modelContext)
        }
    }
    
    /// A list of all days in the current month.
    private var dayList: some View {
        ScrollView {
            LazyVGrid(columns: [column, column, column], spacing: 1) {
                ForEach(plannerModel.displayedDates, id: \.dayID) { date in
                    Button {
                        plannerModel.currentDate = date
                        navigationModel.path.append(date)
                    } label: {
                        LargeDateCell(date: date, planning: planning)
                            .frame(height: columnWidth)
                    }
                    .buttonStyle(.tappable)
                    .matchedTransitionSource(id: date.dayID, in: namespace)
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition($scrollPosition, anchor: .top)
        .transition(.push(from: pushEdge))
        .id(plannerModel.displayedMonth)
        .background(Color(uiColor: .systemGroupedBackground))
        .onAppear { scrollPosition.scrollTo(id: Date().dayID, anchor: .top) }
    }
    
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            // Planning Picker
            Picker("", selection: .init(get: { planning }, set: {
                plannerModel.setCurrentPlanning(to: $0, using: modelContext)
                streakModel.resetWeek()
            })) {
                ForEach(allPlannings) { planning in
                    Text(planning.title)
                        .tag(planning)
                }
            } currentValueLabel: {
                Image(systemName: "calendar")
            }
            .pickerStyle(.menu)
            
            // Shows details of the current planning
            NavigationLink(value: planning) {
                Image(systemName: "line.3.horizontal")
            }
        }
    }
}

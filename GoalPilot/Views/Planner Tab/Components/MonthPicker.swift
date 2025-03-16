//
//  MonthPicker.swift
//  GoalPilot
//
//  Created by Rune Pollet on 30/10/2024.
//

import SwiftUI

struct MonthPicker: View {
    @Environment(PlannerViewModel.self) private var plannerModel
    
    var horizontal: Bool = false
    @Binding var pushEdge: Edge
    
    private let calendar = Calendar.current
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = horizontal ? "MMMM yyyy" : "MMM"
        return formatter
    }
    
    var body: some View {
        Group {
            if horizontal {
                HStack(spacing: 3) { content }
            } else {
                VStack(spacing: 3) { content }
            }
        }
        .padding(.vertical, 10)
        .frame(width: horizontal ? nil : 40)
    }
    
    private var content: some View {
        Group {
            // Back button
            Button {
                pushEdge = horizontal ? .leading : .bottom
                plannerModel.loadDatesForNextMonth(inDirection: .backward, animation: .smooth)
            } label: {
                Image(systemName: horizontal ? "chevron.left" : "chevron.up")
                    .fontWeight(.bold)
            }
            
            // Current Month
            ZStack {
                Text(formatter.string(from: plannerModel.firstDateOfDisplayedMonth))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: horizontal ? .infinity : nil)
                    .transition(.push(from: pushEdge))
                    .id(plannerModel.displayedMonth)
                    .padding(.vertical, horizontal ? 3 : 0)
            }
            .clipped()
            .background {
                if horizontal {
                    Capsule()
                        .foregroundStyle(Color(AssetsCatalog.tertiaryColorID))
                }
            }
            
            // Next Button
            Button {
                pushEdge = horizontal ? .trailing : .top
                plannerModel.loadDatesForNextMonth(inDirection: .forward, animation: .smooth)
            } label: {
                Image(systemName: horizontal ? "chevron.right" : "chevron.down")
                    .fontWeight(.bold)
            }
        }
    }
}

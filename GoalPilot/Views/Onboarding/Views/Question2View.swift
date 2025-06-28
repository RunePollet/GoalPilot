//
//  Question2View.swift
//  GoalPilot
//
//  Created by Rune Pollet on 05/04/2024.
//

import SwiftUI
import SwiftData

struct Question2View: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    @Environment(Goal.self) private var goal
    @Environment(OnboardingViewModel.self) private var onboardingModel
    
    enum Field: Hashable {
        case title, info
    }
    
    @FocusState private var focusedField: Self.Field?
    @State private var showSheet = false
    
    var body: some View {
        QuestionViewLayout(
            preText: ("Tell us more!", .init()),
            title: ("Try to describe your goal and your dream", .init()),
            tip: ("Tip: be as specific as possible to \nreally understand what they are.", .init()),
            customSection: { customSection }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .dismissKeyboardArea {
            focusedField = nil
            keyboardDismissed()
        }
        .onboardingBottomBar(
            nextButton: .init(isDisabled: { !goal.hasTitle }),
            infoButton: {
                print(showSheet)
                showSheet = true
            }
        )
        .sheet(isPresented: $showSheet) {
            sheet
        }
    }
    
    private var customSection: some View {
        @Bindable var goal = goal
        
        return VStack(spacing: 10) {
            // Ultimate goal input
            TextField("Ultimate goal", text: $goal.title)
                .textFieldStyle(OnboardingTextFieldStyle(input: $goal.title, focused: focusedField == .title))
                .focused($focusedField, equals: Self.Field.title)
                .onTapGesture {}
            
            // Info input
            TextField("Description", text: $goal.info.boundString, axis: .vertical)
                .textFieldStyle(OnboardingTextFieldStyle(input: $goal.info.boundString, focused: focusedField == .info, stretch: true))
                .focused($focusedField, equals: Self.Field.info)
                .frame(height: 130)
                .onTapGesture {}
            
            // Bottom caption
            Text("All data and info about you is kept on your device and not shared with anyone. You can always change it later.")
                .font(.caption2)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .autocorrectionDisabled()
        .foregroundStyle(.white)
        .padding(.horizontal)
        .onChange(of: focusedField) { oldValue, newValue in
            if newValue == nil {
                keyboardDismissed()
            }
        }
    }
    
    private var sheet: some View {
        NavigationStack {
            SheetViewLayout(mode: .example, title: "Try to describe your goal\nand your dream") {
                // Custom Section
                VStack(spacing: 20) {
                    ExampleRow(text: "Be financially free and live my dream life")
                    
                    ExampleRow(text: "I’d like to never worry about money, drive a Porsche and an Aston Martin SUV. I want to own my dream house in a quiet place, have a partner and start a family. I will also still be in contact with all my best friends and make many new friends. I’ll travel a lot and visit different places while making money. I’ll also own a vacation home in the south of France.")
                }
                .foregroundStyle(Color.secondary)
                .padding(.horizontal)
            }
        }
    }
    
    func keyboardDismissed() {
        goal.title = goal.title.trimmingCharacters(in: .whitespaces)
        goal.info = goal.info?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

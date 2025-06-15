//
//  MotivationalViewLayout.swift
//  GoalPilot
//
//  Created by Rune Pollet on 18/08/2024.
//

import SwiftUI

/// A layout for a motivational view.
struct MotivationalViewLayout<Icon: View>: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @Environment(Goal.self) private var goal
    @Environment(GlobalViewModel.self) private var globalModel
    @Environment(OnboardingViewModel.self) private var onboardingModel
    @Environment(PlannerViewModel.self) private var plannerModel
    @Environment(StreakViewModel.self) private var streakModel
    
    enum Content {
        case text, tabs
    }
    enum ToolbarType {
        case cancel, keepGoing
    }
    
    var content: Content
    var toolbarType: ToolbarType
    @Binding var showSecondaryIcon: Bool
    var icon: () -> Icon
    var title: String
    var tabs: [(text: String, isQuote: Bool, credits: (label: String, link: String)?)]
    var yOffset: CGFloat
    var dialogTitle: String
    var secondaryButton: ((title: String, completion: () -> Void))?
    
    // View coordination
    @State private var selectedTab = 0
    @State private var showDialog = false
    
    @State private var showDeleteGoalAlert = false
    private let deleteGoalAlert = UIAlertController.deleteGoal(deleteCompletion: {})
    
    init(toolbar: ToolbarType, showSecondaryIcon: (Binding<Bool>)? = nil, icon: @escaping () -> Icon, title: String, labeledText: String, yOffset: CGFloat = 0, dialogTitle: String, secondaryButton: (title: String, completion: () -> Void)? = nil) {
        self.content = .text
        self.toolbarType = toolbar
        self._showSecondaryIcon = showSecondaryIcon ?? .constant(true)
        self.icon = icon
        self.title = title
        self.tabs = [(labeledText, false, nil)]
        self.yOffset = yOffset
        self.dialogTitle = dialogTitle
        self.secondaryButton = secondaryButton
    }
    
    init(toolbar: ToolbarType, showSecondaryIcon: (Binding<Bool>)? = nil, icon: @escaping () -> Icon, title: String, tabs: [(text: String, isQuote: Bool, credits: (label: String, link: String)?)], yOffset: CGFloat = 0, dialogTitle: String, secondaryButton: (title: String, completion: () -> Void)? = nil) {
        self.content = .tabs
        self.toolbarType = toolbar
        self._showSecondaryIcon = showSecondaryIcon ?? .constant(true)
        self.icon = icon
        self.title = title
        self.tabs = tabs
        self.yOffset = yOffset
        self.dialogTitle = dialogTitle
        self.secondaryButton = secondaryButton
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: pct(10/852, of: .height)) {
                // Icon
                icon()
                    .offset(y: yOffset)
                
                Spacer()
                    .limitFrame(maxHeight: 40)
                    .offset(y: yOffset)
                
                // Title
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
                    .offset(y: yOffset)
                
                // Text
                if content == .text {
                    HighlightedLabel(label: tabs[0].text, splitBy: "#")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .offset(y: yOffset)
                } else {
                    TabView(selection: $selectedTab) {
                        ForEach(Array(tabs.enumerated()), id: \.offset) { curTab in
                            tab(curTab.element)
                                .multilineTextAlignment(.center)
                                .tag(curTab.offset)
                                .frame(maxHeight: .infinity, alignment: .top)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    .offset(y: yOffset)
                    .onChange(of: selectedTab) { oldValue, newValue in
                        withAnimation(.smooth) {
                            showSecondaryIcon = newValue > 0
                        }
                    }
                }
            }
            
            Spacer()
            
            if let secondaryButton {
                // Secondary button
                Button(secondaryButton.title) {
                    secondaryButton.completion()
                }
                .padding(.bottom, pct(15/852, of: .height))
                .padding(.horizontal)
            }
            
            Divider()
                .padding(.horizontal)
            
            // Button to proceed
            Button {
                showDialog = true
            } label: {
                HStack(spacing: 5) {
                    Text("I still want to proceed")
                    Image(systemName: "chevron.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 11)
                }
                .foregroundStyle(Color.secondary)
                .padding(.top, 3)
                .padding(.bottom)
            }
            .padding(.horizontal)
        }
        .toolbar {
            // Dismiss button
            ToolbarItem(placement: toolbarType == .cancel ? .cancellationAction : .confirmationAction) {
                if toolbarType == .keepGoing {
                    Button("Keep going") {
                        dismiss()
                        WindowService.window()?.presentAlert(.keptGoingEncouragement)
                    }
                } else {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
        .confirmationDialog("", isPresented: $showDialog) {
            Button(dialogTitle, role: .destructive) {
                showDeleteGoalAlert = true
            }
        }
        .alert(deleteGoalAlert.title ?? "", isPresented: $showDeleteGoalAlert) {
            Button("Cancel", role: .cancel) {}
            
            Button("Continue", role: .destructive) {
                dismiss()
                goal.delete(from: modelContext, onboardingModel: onboardingModel, globalModel: globalModel, plannerModel: plannerModel, streakModel: streakModel)
            }
        } message: {
            if let message = deleteGoalAlert.message {
                Text(message)
            }
        }

    }
    
    private func tab(_ tab: (text: String, isQuote: Bool, credits: (label: String, link: String)?)) -> some View {
        ZStack {
            // Credits
            if let credits = tab.credits, let url = URL(string: credits.link) {
                Link(destination: url) {
                    Group {
                        Text("- ")
                        + Text(credits.label)
                            .underline()
                    }
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                }
                .buttonStyle(.plain)
            }
            
            // Text
            if tab.isQuote {
                Text(tab.text)
                    .font(.system(size: 17, weight: .semibold, design: .default))
                    .foregroundStyle(Color(AssetsCatalog.complementaryColorID))
            } else {
                HighlightedLabel(label: tab.text, splitBy: "#")
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color(uiColor: .secondarySystemGroupedBackground))
                .tileShadow()
                .padding(.top)
        }
        .frame(height: 220)
        .padding(.horizontal)
    }
}

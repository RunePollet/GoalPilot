//
//  OnboardingSequenceView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 29/03/2024.
//

import SwiftUI

struct OnboardingSequenceView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Goal.self) private var goal
    @Environment(OnboardingViewModel.self) private var onboardingModel
    
    @State private var showSheet = false
    @State private var starProgress: CGFloat = 0
    @State private var winkTrigger = false
    private let softImpactGenerator = UIImpactFeedbackGenerator(style: .soft)
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // The onboarding views
                views
                
                if let nextButton = onboardingModel.nextButton, let _ = onboardingModel.secondaryButton {
                    // Next button
                    self.nextButton(nextButton)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
            .toolbar {
                toolbar
            }
            .background {
                background
            }
            .overlay {
                overlay
            }
            .sheet(isPresented: $showSheet) {
                sheetViews
            }
        }
    }
}


// View elements
extension OnboardingSequenceView {
    /// The views to shift through in the onboarding sequence.
    private var views: some View {
        ZStack {
            if onboardingModel.currentView == .welcome {
                WelcomeView()
                    .transition(.push(from: onboardingModel.pushEdge))
            }
            if onboardingModel.currentView == .intro {
                IntroView()
                    .transition(.push(from: onboardingModel.pushEdge))
            }
            if onboardingModel.currentView == .question1 {
                Question1View()
                    .transition(.push(from: onboardingModel.pushEdge))
            }
            if onboardingModel.currentView == .question2 {
                Question2View()
                    .transition(.push(from: onboardingModel.pushEdge))
            }
            if onboardingModel.currentView == .question3 {
                Question3View()
                    .transition(.push(from: onboardingModel.pushEdge))
            }
            if onboardingModel.currentView == .question4 {
                Question4View()
                    .transition(.push(from: onboardingModel.pushEdge))
            }
            if onboardingModel.currentView == .question5 {
                Question5View()
                    .transition(.push(from: onboardingModel.pushEdge))
            }
            if onboardingModel.currentView == .question6 {
                Question6View()
                    .transition(.push(from: onboardingModel.pushEdge))
            }
            if onboardingModel.currentView == .reward {
                RewardView()
                    .transition(.push(from: onboardingModel.pushEdge))
            }
            if onboardingModel.currentView == .endOnboarding {
                EndOnboardingView()
                    .transition(.push(from: onboardingModel.pushEdge))
            }
        }
    }
    
    private func nextButton(_ nextButton: OnboardingViewModel.BottomBarButton) -> some View {
        Button {
            nextButton.performAction(goal: goal, onboardingModel: onboardingModel, modelContext: modelContext)
        } label: {
            Text(nextButton.title)
                .font(.title3)
                .fontWeight(.black)
                .foregroundStyle(.thinMaterial)
                .opacity(nextButton.isDisabled() ? 0.3 : 1)
        }
        .disabled(nextButton.isDisabled())
    }
    
    /// The view to show in the sheet of each view.
    private var sheetViews: some View {
        NavigationStack {
            switch onboardingModel.currentView {
            case .question1:
                Question1View.sheetView
                
            case .question2:
                Question2View.sheetView
                
            case .question3:
                Question3View.sheetView
                
            case .question4:
                Question4View.sheetView
                
            case .question5:
                Question5View.sheetView
                
            case .question6:
                Question6View.sheetView
                
            default:
                Color.clear
            }
        }
    }
    
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        // Back button
        ToolbarItem(placement: .navigation) {
            Button {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                onboardingModel.previousView()
            } label: {
                HStack(spacing: 3) {
                    Image(systemName: "chevron.left")
                        .fontWeight(.semibold)
                    Text("Back")
                }
                .opacity(onboardingModel.currentView.rawValue > (onboardingModel.isBeingReused ? 2 : 1) ? 1 : 0)
            }
        }
        
        // Sheet button
        ToolbarItem(placement: .primaryAction) {
            Button {
                showSheet = true
            } label: {
                Text(onboardingModel.currentView.rawValue <= OnboardingViewModel.Views.question1.rawValue ? "Get Inspiration" : "Example")
                    .frame(width: 115, alignment: .trailing)
                    .opacity(onboardingModel.currentView.rawValue > 2 && onboardingModel.currentView.rawValue < 9 ? 1 : 0)
            }
        }
        
        // Bottom bar
        ToolbarItem(placement: .bottomBar) {
            ZStack {
                if let secondaryButton = onboardingModel.secondaryButton {
                    // Secondary Button
                    Button {
                        secondaryButton.performAction(goal: goal, onboardingModel: onboardingModel, modelContext: modelContext)
                    } label: {
                        Text(secondaryButton.title)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.thinMaterial)
                    }
                } else if let nextButton = onboardingModel.nextButton {
                    self.nextButton(nextButton)
                }
            }
        }
    }
    
    private var background: some View {
        GeometryReader { geo in
            let screenWidth = geo.size.width
            let screenHeight = geo.size.height
            let totalWidth = screenWidth * 10
            let offset = screenWidth * CGFloat((onboardingModel.currentView.rawValue-1))
            
            // Background Hills
            ZStack(alignment: .bottomLeading) {
                // Sky
                Landscape.SkyGradient(timeOfDay: .day)
                
                // Sea
                Rectangle()
                    .frame(height: screenHeight * 241/852)
                    .foregroundStyle(Color(AssetsCatalog.seaColorID))
                
                Group {
                    // Hills
                    Landscape.HillView(.thirdOnboarding)
                    Landscape.PathwayView(.onboarding, style: .focused, glow: false)
                    Landscape.HillView(.secondOnboarding)
                    Landscape.HillView(.firstOnboarding)
                    
                    // Sky
                    Landscape.Cloud(variation: .two)
                        .frame(width: screenWidth * 57.11/393, height: screenWidth * 47.64/393)
                        .offset(x: 3008/3930 * totalWidth, y: screenHeight * -752.77/852)
                    Landscape.Cloud(variation: .one)
                        .frame(width: screenWidth * 52.67/393, height: screenWidth * 38.5/393)
                        .offset(x: 3457/3930 * totalWidth, y: screenHeight * -715.64/852)
                    Landscape.Cloud(variation: .two)
                        .frame(width: screenWidth * 57.11/393, height: screenWidth * 47.64/393)
                        .offset(x: 3605/3930 * totalWidth, y: screenHeight * -740.77/852)
                    Landscape.Cloud(variation: .one)
                        .frame(width: screenWidth * 52.67/393, height: screenWidth * 38.5/393)
                        .offset(x: 3704/3930 * totalWidth, y: screenHeight * -603.5/852)
                    Landscape.Sun()
                        .frame(width: screenWidth * 41/393)
                        .offset(x: 3829.5/3930 * totalWidth, y: screenHeight * 86.5/852)
                }
                .offset(x: -offset)
            }
        }
        .ignoresSafeArea()
    }
    
    private var overlay: some View {
        // Star
        GeometryReader { geo in
            let screenWidth = geo.size.width
            let totalWidth = screenWidth * 10
            let offset = screenWidth * CGFloat((onboardingModel.currentView.rawValue-1))
            
            // Star configuration
            let leftEye = StarFigure.Eye(
                side: .left,
                frame: (30/300, 45/300), pupilFrame: (9.14/20.2, 10.73/29.18))
            let leftEyebrow = StarFigure.Eyebrow(
                side: .left,
                frame: (40/300, 20/300),
                rotation: .degrees(-15),
                offset: (3/300, -40/300))
            let rightEye = StarFigure.Eye(
                side: .right,
                closed: true,
                frame: (30/300, 45/300), pupilFrame: (9.14/20.2, 10.73/29.18))
            let rightEyebrow = StarFigure.Eyebrow(
                side: .right,
                frame: (40/300, 20/300),
                rotation: .degrees(15),
                offset: (-3/300, -40/300))
            let mouth = StarFigure.Mouth(frame: (70/300, 53.85/300))
            let initialValue = StarFigure.StarViewConfiguration(
                leftEye: leftEye,
                rightEye: rightEye,
                leftEyebrow: leftEyebrow,
                rightEyebrow: rightEyebrow,
                mouth: mouth)
            
            MoveAlongCurve(
                progress: starProgress,
                content: { path in
                    Group {
                        StarFigure.StarView(config: initialValue)
                            .keyframeAnimator(initialValue: initialValue, trigger: winkTrigger) { content, value in
                                StarFigure.StarView(config: value)
                            } keyframes: { value in
                                StarFigure.StarView.winkKeyframes(value)
                            }
                            .onChange(of: winkTrigger) {
                                let generator = UIImpactFeedbackGenerator(style: .rigid)
                                generator.prepare()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                                    generator.impactOccurred()
                                    generator.prepare()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.44) {
                                    generator.impactOccurred()
                                }
                            }
                        StarFigure.StarShape()
                            .opacity(starProgress == 0 ? 1 : 0)
                    }
                    .frame(width: pct(starProgress == 1 ? 212.65/393 : 38/393, of: .minDimension), height: pct(starProgress == 1 ? 212.65/393 : 38/393, of: .minDimension))
                    .foregroundStyle(Color(AssetsCatalog.goalColorID))
                    .shadow(radius: starProgress == 0 ? 21 : 15)
                },
                departPosition: UnitPoint(x: 338/393, y: 179/852),
                destinationPosition: UnitPoint(x: 589/393, y: 300/852), pathProvider: { path, departure, destination, size in
                    let height = size.height
                    
                    path.move(to: departure)
                    path.addCurve(to: destination, control1: CGPoint(x: departure.x, y: height*0.1), control2: CGPoint(x: destination.x, y: height*0.1))
                }
            )
            .frame(width: screenWidth)
            .offset(x: 2751/3930 * totalWidth)
            .offset(x: -offset)
        }
        .ignoresSafeArea()
        .onChange(of: onboardingModel.currentView, initial: true) { oldValue, newValue in
            if newValue == .reward && oldValue == .question6 {
                // Let the star grow and wink
                softImpactGenerator.impactOccurred()
                withAnimation(.easeInOut(duration: 1)) {
                    starProgress = 1
                } completion: {
                    winkTrigger.toggle()
                }
            } else if newValue == .question6 && oldValue == .reward {
                // Shrink the star
                withAnimation(.easeInOut(duration: 1)) {
                    starProgress = 0
                }
            } else if newValue.rawValue >= OnboardingViewModel.Views.reward.rawValue {
                // Don't animate the star
                if starProgress != 1 {
                    starProgress = 1
                }
            }
        }
    }
}

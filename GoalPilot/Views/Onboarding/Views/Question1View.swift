//
//  Question1View.swift
//  GoalPilot
//
//  Created by Rune Pollet on 05/04/2024.
//

import SwiftUI

struct Question1View: View {
    @Environment(OnboardingViewModel.self) private var onboardingModel
    
    var body: some View {
        QuestionViewLayout(
            preText: ("Imagine you wake up tomorrow \nliving your dream life.", .init()),
            title: ("How would it look like?", .init()),
            customSection: { customSection }
        )
        .onboardingBottomBarSetter {
            onboardingModel.nextButton = .init(completion: {
                // Show a message to the user
                let alert = UIAlertController(title: "Great!", message: "Answer the following questions to continue. Take as much time as needed for each question, you can even do some research if you want. Your progress will be saved so you'll be able to continue at any time.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                WindowService.window()?.presentAlert(alert, canBeRepeated: false)
            })
        }
    }
    
    private var customSection: some View {
        // Tips
        VStack(spacing: 10) {
            HighlightedLabel(label: "Think very creatively, it can be anything, and most importantly, it has to be what *you* want.", splitBy: "*")
            
            HighlightedLabel(label: "Tip: Don't worry about being selfish, this is the time to think about *your own dream*, not others' dreams for you.", splitBy: "*")
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal)
    }
    
    func showMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        WindowService.window()?.presentAlert(alert, canBeRepeated: false)
    }
}

// Elements for the sheet
extension Question1View {
    static var sheetView: some View {
        SheetViewLayout(mode: .inspiration, intro: "Imagine you wake up tomorrow \nliving your dream life.", title: "How would it look like?") {
            // Custom Section
            inspiration
        }
    }
    
    static private var inspiration: some View {
        let inspiration: [[String]] = [
            ["*Where* would you wake up?"],
            ["*What* would you do that day?", "With *who*?"],
            ["In what kind of *house* would you live?"],
            ["Who would your *friends* be?", "What kind of friends would you have?"],
            ["Is there something you’d *own*?"],
            ["What would your *routines* be?", "Where would you do these?", "With who?"],
            ["What would your *financial situation* be like?"],
            ["*What would you be doing* to be able to live this life?"]
        ]
        
        return TabView {
            // Tabs
            ForEach(inspiration, id: \.self) { inspiration in
                
                // Inspiration
                VStack(spacing: 0) {
                    ForEach(inspiration, id: \.self) { text in
                        HighlightedLabel(label: text, splitBy: "*")
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: pct(150/852, of: .height))
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.white)
                }
                .padding(.horizontal)
                
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .tabViewStyle(.page)
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .frame(height: pct(204/852, of: .height))
    }
}

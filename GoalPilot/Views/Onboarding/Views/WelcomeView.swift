//
//  WelcomeView.swift
//  GoalPilot
//
//  Created by Rune Pollet on 03/04/2024.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(OnboardingViewModel.self) private var onboardingModel
    @Environment(GlobalViewModel.self) private var globalModel
    
    @State private var givenName: String = ""
    @FocusState private var focused: Bool
    @State private var textService = TextService.shared
    
    var body: some View {
        
        VStack(spacing: 0) {
            Spacer()
                .limitFrame(maxHeight: pct(90/852, of: .height))
            
            VStack(spacing: 10) {
                Text("Hey there!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("We're excited to see you!\nHow may we call you?")
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
                .limitFrame(maxHeight: pct(192/852, of: .height))
            
            nameInput
        }
        .foregroundStyle(.white)
        .frame(maxHeight: .infinity, alignment: .top)
        .dismissKeyboardArea {
            focused = false
        }
        .onboardingBottomBarSetter {
            onboardingModel.nextButton = .init(title: "Next", isDisabled: { textService.username.isEmpty })
        }
        .onAppear {
            self.givenName = textService.username.trimmingCharacters(in: .whitespaces)
        }
        
    }
    
    var nameInput: some View {
        VStack(spacing: 10) {
            TextField("Name", text: $givenName)
                .focused($focused)
                .textFieldStyle(OnboardingTextFieldStyle(input: $givenName, focused: focused))
                .textContentType(.nickname)
                .autocorrectionDisabled(true)
                .submitLabel(.done)
                .onChange(of: givenName) {
                    // Save the name
                    textService.username = givenName
                }
                .onSubmit {
                    if !givenName.isEmpty {
                        onboardingModel.nextView()
                    }
                }
                .padding(.horizontal, 37)
                .padding(.bottom)
        }
    }
}

//
//  ModelInserter.swift
//  GoalPilot
//
//  Created by Rune Pollet on 11/09/2024.
//

import SwiftUI
import SwiftData

struct ModelInserter<Model: PersistentModel & Persistentable>: ViewModifier {
    @Environment(\.modelContext) private var modelContext
    
    var model: Model
    var insertDelay: Double
    var insertCompletion: (() -> Void)?
    var cancelCompletion: (() -> Void)?
    var doneCompletion: (() -> Void)?
    var dismissAction: (() -> Void)?
    
    @State private var didInsert = false
    
    func body(content: Content) -> some View {  
        content
            .navigationBarBackButtonHidden()
            .interactiveDismissDisabled()
            .onAppear {
                let insertedModel: Model? = modelContext.registeredModel(for: model.persistentModelID)
                if insertedModel == nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + insertDelay) {
                        model.insert(into: modelContext)
                        insertCompletion?()
                        didInsert = true
                    }
                }
            }
            .toolbar {
                DoneToolbarItems(showCancel: true, disableDone: !model.isConfigured, doneCompletion: doneCompletion, cancelCompletion: {
                    if didInsert {
                        model.delete(from: modelContext)
                    }
                    cancelCompletion?()
                }, dismissAction: dismissAction)
            }
            .onScenePhaseChange(to: .background) {
                model.delete(from: modelContext)
            }
    }
}

extension View {
    /// Handles the action of inserting and deleting the model in the model context and provides a save-cancel bar.
    func modelInserter<Model: Persistentable>(model: Model, delay: Double = 0, insertCompletion: (() -> Void)? = nil, cancelCompletion: (() -> Void)? = nil, doneCompletion: (() -> Void)? = nil, dismissAction: (() -> Void)? = nil) -> some View {
        modifier(ModelInserter(model: model, insertDelay: delay, insertCompletion: insertCompletion, cancelCompletion: cancelCompletion, doneCompletion: doneCompletion, dismissAction: dismissAction))
    }
}

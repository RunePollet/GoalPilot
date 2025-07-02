//
//  Goal.swift
//  GoalPilot
//
//  Created by Rune Pollet on 16/06/2024.
//
//

import SwiftData
import SwiftUI

@Model
final class Goal {
    #Unique<Goal>([\.id])
    
    var id: String = "GoalID"
    var title: String
    var info: String?
    var chosenWay: String
    var pathSummary: String?
    var achieved: Bool
    var isDeleted: Bool
    
    @Relationship(deleteRule: .cascade, inverse: \Pillar.parent)
    var pillars: [Pillar]
    
    @Relationship(deleteRule: .cascade, inverse: \Milestone.parent)
    var milestones: [Milestone]
    
    @Relationship(deleteRule: .cascade, inverse: \Requirement.parent)
    var requirements: [Requirement]
    
    @Relationship(deleteRule: .cascade, inverse: \Reminder.parent)
    var reminders: [Reminder]
    
    init(title: String, info: String? = nil, chosenWay: String = "", pathSummary: String? = nil, pillars: [Pillar] = [], milestones: [Milestone] = [], requirements: [Requirement] = [], reminders: [Reminder] = []) {
        self.title = title
        self.info = info
        self.chosenWay = chosenWay
        self.pathSummary = pathSummary
        self.achieved = false
        self.isDeleted = false
        self.pillars = pillars
        self.milestones = milestones
        self.requirements = requirements
        self.reminders = reminders
    }
    
    
    // MARK: Accessibilities
    var highestOrderIndex: Int { milestones.sorted { $0.orderIndex > $1.orderIndex }.first?.orderIndex ?? 0 }
    
    /// Sets the achieved property of the goal to the given value.
    @MainActor
    func setAchieved(_ achieved: Bool, currentPlanning: Planning?) {
        withAnimation(.easeOut(duration: 0.7)) {
            self.achieved = achieved
        }
        
        if achieved {
            // Remove all pending notification requests
            let notificationService = NotificationService.shared
            notificationService.removeAllNotifications()
            NotificationService.shared.lock()
        } else {
            // Add all current notifications
            let notificationService = NotificationService.shared
            notificationService.unlock()
            
            if let currentPlanning {
                notificationService.addAllNotifications(for: currentPlanning)
            }
            for reminder in reminders {
                reminder.updateNotification(active: true)
            }
        }
    }
    
    
    // MARK: Configure Support
    var hasTitle: Bool { !title.isEmpty }
    var hasChosenWay: Bool { !chosenWay.isEmpty }
    var hasPillars: Bool { !pillars.isEmpty }
    var hasMilestones: Bool { !milestones.isEmpty }
    var hasRequirements: Bool { !requirements.isEmpty }
    
    var isConfigured: Bool { hasTitle && hasChosenWay && hasPillars && hasMilestones && hasRequirements }
    
    
    // MARK: Data Management
    static func get(from context: ModelContext) -> Goal {
        var descriptor = FetchDescriptor<Goal>()
        descriptor.fetchLimit = 1
        
        guard let goal = (try? context.fetch(descriptor).first) else {
            let newGoal = Goal(title: "")
            do {
                try context.transaction { context.insert(newGoal) }
            } catch {
                print("Goal insertion failed: \(error.localizedDescription)")
            }
            return newGoal
        }
        
        return goal
    }
    
    func delete(from modelContext: ModelContext, onboardingModel: OnboardingViewModel, globalModel: GlobalViewModel, plannerModel: PlannerViewModel, streakModel: StreakViewModel) {
        // Delete the goal
        isDeleted = true
        do {
            try modelContext.transaction { modelContext.delete(self) }
        } catch {
            print("Goal deletion failed: \(error.localizedDescription)")
        }
        
        // Reuse the onboarding
        onboardingModel.reuse()
        
        // Prepare the app for reuse
        globalModel.cleanUp(plannerModel: plannerModel, streakModel: streakModel)
    }
}

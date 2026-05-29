//
//  ActivityViewModel.swift
//  ALP_MAD
//
//  Created by Dave on 29/05/26.
//

import Foundation
import FirebaseFirestore

@Observable
class ActivityViewModel {
    var activities: [ActivityModel] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    // Add/Edit form state
    var activityName: String = ""
    var staminaReward: String = ""
    var expReward: String = ""
    var editingActivity: ActivityModel?
    var showAddSheet: Bool = false
    var showEditSheet: Bool = false
    
    private let activityService = ActivityService.shared
    private let userService = UserService.shared
    private var listener: ListenerRegistration?
    
    deinit {
        listener?.remove()
    }
    
    // MARK: - Load Activities
    func loadActivities(userId: String) {
        listener?.remove()
        listener = activityService.addActivitiesListener(userId: userId) { [weak self] activities in
            Task { @MainActor in
                self?.activities = activities
                WatchConnectivityService.shared.sendActivities(activities)
            }
        }
    }
    
    // MARK: - Add Activity
    func addActivity(userId: String) async {
        guard !activityName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Activity name cannot be empty"
            return
        }
        guard let stamina = Int(staminaReward), stamina > 0 else {
            errorMessage = "Stamina reward must be a positive number"
            return
        }
        guard let exp = Int(expReward), exp > 0 else {
            errorMessage = "EXP reward must be a positive number"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let activity = ActivityModel(
                userId: userId,
                name: activityName.trimmingCharacters(in: .whitespaces),
                staminaReward: stamina,
                expReward: exp
            )
            try await activityService.createActivity(activity)
            clearForm()
            showAddSheet = false
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Edit Activity
    func updateActivity() async {
        guard var activity = editingActivity else { return }
        guard !activityName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Activity name cannot be empty"
            return
        }
        guard let stamina = Int(staminaReward), stamina > 0 else {
            errorMessage = "Stamina reward must be a positive number"
            return
        }
        guard let exp = Int(expReward), exp > 0 else {
            errorMessage = "EXP reward must be a positive number"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            activity.name = activityName.trimmingCharacters(in: .whitespaces)
            activity.staminaReward = stamina
            activity.expReward = exp
            try await activityService.updateActivity(activity)
            clearForm()
            showEditSheet = false
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Complete Activity
    func completeActivity(activity: ActivityModel, userId: String) async {
        errorMessage = nil
        
        do {
            // Increment completion count
            try await activityService.completeActivity(activityId: activity.id)
            
            // Add stamina & EXP to user
            var user = try await userService.getUser(userId: userId)
            try await userService.addStaminaAndExp(
                userId: userId,
                stamina: activity.staminaReward,
                exp: activity.expReward,
                user: &user
            )
            
            // Sync to watch
            WatchConnectivityService.shared.sendUserData(user)
            WatchConnectivityService.shared.sendActivities(activities)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Delete Activity
    func deleteActivity(activity: ActivityModel) async {
        do {
            try await activityService.deleteActivity(activityId: activity.id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Form Helpers
    func prepareEdit(activity: ActivityModel) {
        editingActivity = activity
        activityName = activity.name
        staminaReward = "\(activity.staminaReward)"
        expReward = "\(activity.expReward)"
        showEditSheet = true
    }
    
    func prepareAdd() {
        clearForm()
        showAddSheet = true
    }
    
    func clearForm() {
        activityName = ""
        staminaReward = ""
        expReward = ""
        editingActivity = nil
        errorMessage = nil
    }
    
    func cleanup() {
        listener?.remove()
        listener = nil
    }
}

//
//  ProfileViewModel.swift
//  ALP_MAD
//
//  Created by Nicholas Leroy Kurniawan on 27/5/26.
//

import Foundation
import FirebaseFirestore

@Observable
class ProfileViewModel {
    var user: UserModel?
    var isLoading: Bool = false
    var errorMessage: String?
    var successMessage: String?
    
    var editUsername: String = ""
    var showEditUsername: Bool = false
    
    var customTimerValue: Int = 10 // For developer cheat
    
    private let userService = UserService.shared
    private var userListener: ListenerRegistration?
    
    deinit {
        userListener?.remove()
    }
    
    // MARK: - Load User
    func loadUser(userId: String) {
        userListener?.remove()
        userListener = userService.addUserListener(userId: userId) { [weak self] user in
            Task { @MainActor in
                guard let u = user else {
                    try? AuthService.shared.logout()
                    return
                }
                self?.user = u
            }
        }
    }
    
    // MARK: - Update Username
    func updateUsername(userId: String) async {
        let trimmed = editUsername.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            errorMessage = "Username cannot be empty"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await userService.updateUsername(userId: userId, username: trimmed)
            user?.username = trimmed
            showEditUsername = false
            successMessage = "Username updated!"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.successMessage = nil
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Developer Cheats
    func cheatAddStreak(userId: String) async {
        do {
            if var u = user {
                let _ = try await userService.updateStreak(user: &u, won: true)
                WatchConnectivityService.shared.sendUserData(u)
            }
        } catch { print("Cheat Error: \(error)") }
    }
    
    func cheatKillBoss(userId: String) async {
        do {
            if var u = user {
                let boss = try await BossService.shared.attackBoss(userId: userId, damage: 999999)
                if boss.isDefeated {
                    let _ = try await userService.updateStreak(user: &u, won: true)
                }
                WatchConnectivityService.shared.sendBossData(boss)
                WatchConnectivityService.shared.sendUserData(u)
            }
        } catch { print("Cheat Error: \(error)") }
    }
    
    func cheatForceSpawnNewBoss(userId: String) async {
        do {
            // Make the system think the current boss is from yesterday
            let db = Firestore.firestore()
            try await db.collection("bosses").document(userId).updateData(["spawnDate": "2020-01-01"])
        } catch { print("Cheat Error: \(error)") }
    }
    
    func prepareEditUsername() {
        editUsername = user?.username ?? ""
        showEditUsername = true
    }
    
    func cleanup() {
        userListener?.remove()
        userListener = nil
    }
}

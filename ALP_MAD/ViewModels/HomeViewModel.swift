//
//  HomeViewModel.swift
//  ALP_MAD
//
//  Created by Nicholas Leroy Kurniawan on 27/5/26.
//

import Foundation
import FirebaseFirestore

@Observable
class HomeViewModel {
    var user: UserModel?
    var isLoading: Bool = false
    var errorMessage: String?
    
    private let userService = UserService.shared
    private let bossService = BossService.shared
    private var userListener: ListenerRegistration?
    
    init() {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            self.user = UserModel(id: "test", username: "PreviewPlayer", email: "preview@test.com", level: 10, exp: 50, expToNextLevel: 100, damage: 10, stamina: 100, maxStamina: 100, dailyStreak: 5, totalStreak: 10, activeBuffs: [], lastBossDefeatDate: nil, totalBossesDefeated: 5, createdAt: Date(), isAdmin: false)
        }
    }
    
    deinit {
        userListener?.remove()
    }
    
    func loadUser(userId: String) {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" { return }
        userListener?.remove()
        userListener = userService.addUserListener(userId: userId) { [weak self] user in
            Task { @MainActor in
                guard let u = user else {
                    try? AuthService.shared.logout()
                    return
                }
                
                self?.user = u
                WatchConnectivityService.shared.sendUserData(u)
            }
        }
    }
    
    func checkDailyBossStatus(userId: String) async {
        do {
            let bossOk = try await bossService.checkYesterdayBossResult(userId: userId)
            if !bossOk {
                var currentUser = self.user
                if currentUser == nil {
                    currentUser = try await userService.getUser(userId: userId)
                }
                
                if var u = currentUser {
                    let _ = try await userService.updateStreak(user: &u, won: false)
                    self.user = u
                }
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func cleanup() {
        userListener?.remove()
        userListener = nil
    }
}

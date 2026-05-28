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
    
    deinit {
        userListener?.remove()
    }
    
    // MARK: - Load User Data
    func loadUser(userId: String) {
        userListener?.remove()
        userListener = userService.addUserListener(userId: userId) { [weak self] user in
            Task { @MainActor in
                // If user data is missing in Firestore, force logout
                guard let u = user else {
                    try? AuthService.shared.logout()
                    return
                }
                
                self?.user = u
                WatchConnectivityService.shared.sendUserData(u)
            }
        }
    }
    
    // MARK: - Check Boss Status (for streak reset)
    func checkDailyBossStatus(userId: String) async {
        do {
            let bossOk = try await bossService.checkYesterdayBossResult(userId: userId)
            if !bossOk, var user = self.user {
                // Streak reset — boss not defeated yesterday
                let _ = try await userService.updateStreak(user: &user, won: false)
                self.user = user
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

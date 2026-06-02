//
//  BossViewModel.swift
//  ALP_MAD
//
//  Created by Hendrawan Saputro on 29/05/26.
//

import Foundation
import FirebaseFirestore

@Observable
class BossViewModel {
    var boss: BossModel?
    var user: UserModel?
    var isLoading: Bool = false
    var errorMessage: String?
    var lastDamageDealt: Int = 0
    var showDamageAnimation: Bool = false
    var showDefeatAnimation: Bool = false
    var newBuff: BuffModel?
    var showBuffAlert: Bool = false
    
    var hoursLeft: Int = 0
    var minutesLeft: Int = 0
    var secondsLeft: Int = 0
    
    private let bossService = BossService.shared
    private let userService = UserService.shared
    private var bossListener: ListenerRegistration?
    private var userListener: ListenerRegistration?
    private var timer: Timer?
    
    init() {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            self.user = UserModel(id: "test", username: "PreviewPlayer", email: "preview@test.com", level: 10, exp: 50, expToNextLevel: 100, damage: 10, stamina: 100, maxStamina: 100, dailyStreak: 5, totalStreak: 10, activeBuffs: [], lastBossDefeatDate: nil, totalBossesDefeated: 5, createdAt: Date(), isAdmin: false)
            self.boss = BossModel(id: "1", userId: "test", bossName: "Slime", maxHp: 100, currentHp: 50, spawnDate: "2026-06-02", isDefeated: false, defeatCount: 0)
        }
    }
    
    deinit {
        cleanup()
    }
    
    func loadData(userId: String) async {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" { return }
        isLoading = true
        
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
        
        do {
            var fetchedUser = try await userService.getUser(userId: userId)
        
            let bossOk = try await bossService.checkYesterdayBossResult(userId: userId)
            if !bossOk {
                let _ = try await userService.updateStreak(user: &fetchedUser, won: false)
            }
            
            let boss = try await bossService.getOrSpawnBoss(userId: userId, currentDefeatCount: 0)
            self.boss = boss
        } catch let err as NSError where err.code == 404 {
            try? AuthService.shared.logout()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        bossListener?.remove()
        bossListener = bossService.addBossListener(userId: userId) { [weak self] boss in
            Task { @MainActor in
                self?.boss = boss
                if let b = boss {
                    WatchConnectivityService.shared.sendBossData(b)
                }
            }
        }
        
        isLoading = false
        startTimer()
    }
    
    func attackBoss() async {
        guard let user = user, let boss = boss else { return }
        guard boss.isAlive else {
            errorMessage = "Boss already defeated! Wait for next spawn."
            return
        }
        guard user.stamina >= GameConstants.attackStaminaCost else {
            errorMessage = "Not enough stamina! Complete activities to gain stamina."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let userId = user.id
            let damage = user.effectiveDamage
            
            var updatedUser = user
            let success = try await userService.useStamina(
                userId: userId,
                amount: GameConstants.attackStaminaCost,
                user: &updatedUser
            )
            
            guard success else {
                errorMessage = "Not enough stamina!"
                isLoading = false
                return
            }
            
            let updatedBoss = try await bossService.attackBoss(userId: userId, damage: damage)
            
            lastDamageDealt = damage
            showDamageAnimation = true
            
            if updatedBoss.isDefeated {
                showDefeatAnimation = true
                
                let buff = try await userService.updateStreak(user: &updatedUser, won: true)
                
                let bonusExp = GameConstants.bossDefeatExpBonus(bossMaxHp: updatedBoss.maxHp)
                try await userService.addStaminaAndExp(userId: userId, stamina: 0, exp: bonusExp, user: &updatedUser)
                
                if let buff = buff {
                    newBuff = buff
                    showBuffAlert = true
                }
            }
            
            self.user = updatedUser
            self.boss = updatedBoss
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showDamageAnimation = false
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        updateTimeLeft()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateTimeLeft()
            }
        }
    }
    
    private func updateTimeLeft() {
        let time = Date().timeUntilNextSpawn()
        
        let wasRunning = hoursLeft > 0 || minutesLeft > 0 || secondsLeft > 0
        let isNowZero = time.hours == 0 && time.minutes == 0 && time.seconds == 0
        
        hoursLeft = time.hours
        minutesLeft = time.minutes
        secondsLeft = time.seconds
        
        let isFakeTimerFinished = (GameConstants.fakeNextSpawnDate != nil) && isNowZero
        
        if (wasRunning && isNowZero) || isFakeTimerFinished {
            if GameConstants.fakeNextSpawnDate != nil {
                handleCheatTimerFinished()
            } else {
                handleRealTimerFinished()
            }
        }
    }
    
    private func handleRealTimerFinished() {
        guard let userId = user?.id else { return }
        Task {
            let bossOk = try? await bossService.checkYesterdayBossResult(userId: userId)
            if bossOk == false, var u = self.user {
                let _ = try? await userService.updateStreak(user: &u, won: false)
            }
            
            await loadData(userId: userId)
        }
    }
    
    private func handleCheatTimerFinished() {
        GameConstants.fakeNextSpawnDate = nil
        
        guard let userId = user?.id ?? AuthService.shared.currentUserId else { return }
        
        Task {
            let db = Firestore.firestore()
            
            try? await db.collection("bosses").document(userId).updateData(["spawnDate": "2020-01-01"])
            
            let bossOk = try? await bossService.checkYesterdayBossResult(userId: userId)
            if bossOk == false, var u = self.user {
                let _ = try? await userService.updateStreak(user: &u, won: false)
            }
            
            await loadData(userId: userId)
        }
    }
    
    var timeLeftString: String {
        return String(format: "%02d:%02d:%02d", hoursLeft, minutesLeft, secondsLeft)
    }
    
    var canAttack: Bool {
        guard let user = user, let boss = boss else { return false }
        return boss.isAlive && user.stamina >= GameConstants.attackStaminaCost
    }
    
    func cleanup() {
        bossListener?.remove()
        userListener?.remove()
        timer?.invalidate()
        bossListener = nil
        userListener = nil
        timer = nil
    }
}

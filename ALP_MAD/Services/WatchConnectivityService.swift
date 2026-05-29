//
//  WatchConnectivityService.swift
//  ALP_MAD
//
//  Created by Hendrawan Saputro on 29/05/26.
//

import Foundation
import WatchConnectivity
import Combine
import FirebaseFirestore

class WatchConnectivityService: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = WatchConnectivityService()
    
    var onCompleteActivity: ((String) async -> Void)?
    var onAttackBoss: (() async -> Void)?
    
    private override init() {
        super.init()
    }
    
    func activate() {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        session.delegate = self
        session.activate()
    }
    
    
    private var currentContext: [String: Any] = [:]
    
    private func updateContext(with newValues: [String: Any]) {
        currentContext.merge(newValues) { (_, new) in new }
        guard WCSession.default.isPaired, WCSession.default.isWatchAppInstalled else { return }
        try? WCSession.default.updateApplicationContext(currentContext)
    }
    
    func sendAuthStatus(isLoggedIn: Bool) {
        if !isLoggedIn {
            currentContext.removeAll()
        }
        updateContext(with: ["isLoggedIn": isLoggedIn])
    }
    
    func sendUserData(_ user: UserModel) {
        updateContext(with: [
            "stamina": user.stamina,
            "maxStamina": user.effectiveMaxStamina,
            "level": user.level,
            "damage": user.effectiveDamage
        ])
    }
    
    func sendActivities(_ activities: [ActivityModel]) {
        let list = activities.map { activity -> [String: Any] in
            return [
                "id": activity.id,
                "name": activity.name,
                "staminaReward": activity.staminaReward,
                "expReward": activity.expReward,
                "completionCount": activity.completionCount
            ]
        }
        updateContext(with: ["activities": list])
    }
    
    func sendBossData(_ boss: BossModel) {
        updateContext(with: [
            "bossName": boss.bossName,
            "bossCurrentHp": boss.currentHp,
            "bossMaxHp": boss.maxHp,
            "bossIsDefeated": boss.isDefeated
        ])
    }
    
    
    nonisolated func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WCSession activated: \(activationState.rawValue)")
        if activationState == .activated {
            Task { @MainActor in
                self.syncAllDataToWatch()
            }
        }
    }
    
    @MainActor
    func syncAllDataToWatch() {
        guard let userId = AuthService.shared.currentUserId else {
            self.sendAuthStatus(isLoggedIn: false)
            return
        }
        self.sendAuthStatus(isLoggedIn: true)
        
        Task {
            do {
                if let user = try? await UserService.shared.getUser(userId: userId) {
                    self.sendUserData(user)
                    
                    if let doc = try? await Firestore.firestore().collection("bosses").document(userId).getDocument(),
                       let data = doc.data(),
                       let boss = try? Firestore.Decoder().decode(BossModel.self, from: data) {
                        self.sendBossData(boss)
                    }
                    
                    if let activities = try? await ActivityService.shared.getActivities(userId: userId) {
                        self.sendActivities(activities)
                    }
                }
            }
        }
    }
    
    nonisolated func sessionDidBecomeInactive(_ session: WCSession) {}
    nonisolated func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    
    nonisolated func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        let action = message["action"] as? String
        
        Task { @MainActor in
            guard let userId = AuthService.shared.currentUserId else {
                self.sendAuthStatus(isLoggedIn: false)
                replyHandler(["status": "error"])
                return
            }
            
            switch action {
            case "complete_activity":
                if let activityId = message["activityId"] as? String {
                    do {
                        let activities = try await ActivityService.shared.getActivities(userId: userId)
                        if let activity = activities.first(where: { $0.id == activityId }) {
                            try await ActivityService.shared.completeActivity(activityId: activityId)
                            var user = try await UserService.shared.getUser(userId: userId)
                            try await UserService.shared.addStaminaAndExp(userId: userId, stamina: activity.staminaReward, exp: activity.expReward, user: &user)
                            self.sendUserData(user)
                            let newActivities = try await ActivityService.shared.getActivities(userId: userId)
                            self.sendActivities(newActivities)
                        }
                    } catch { print("Error: \(error)") }
                }
                replyHandler(["status": "ok"])
                
            case "attack_boss":
                do {
                    var user = try await UserService.shared.getUser(userId: userId)
                    let success = try await UserService.shared.useStamina(userId: userId, amount: GameConstants.attackStaminaCost, user: &user)
                    if success {
                        let boss = try await BossService.shared.attackBoss(userId: userId, damage: user.effectiveDamage)
                        if boss.isDefeated {
                            let _ = try await UserService.shared.updateStreak(user: &user, won: true)
                            let exp = GameConstants.bossDefeatExpBonus(bossMaxHp: boss.maxHp)
                            try await UserService.shared.addStaminaAndExp(userId: userId, stamina: 0, exp: exp, user: &user)
                        }
                        self.sendUserData(user)
                        self.sendBossData(boss)
                    }
                } catch { print("Error: \(error)") }
                replyHandler(["status": "ok"])
                
            default:
                replyHandler(["status": "unknown"])
            }
        }
    }
}

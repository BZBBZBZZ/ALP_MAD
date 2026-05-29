//
//  WatchSessionServices.swift
//  watch-os Watch App
//
//  Created by Dave on 29/05/26.
//

import Foundation
import WatchConnectivity
import SwiftUI

@Observable
class WatchSessionService: NSObject, WCSessionDelegate {
    static let shared = WatchSessionService()
    
    // Data received from iOS
    var stamina: Int = 0
    var maxStamina: Int = 100
    var level: Int = 1
    var damage: Int = 10
    var activities: [[String: Any]] = []
    
    var bossName: String = "Unknown Boss"
    var bossCurrentHp: Int = 100
    var bossMaxHp: Int = 100
    var bossIsDefeated: Bool = false
    
    var isConnected: Bool = false
    var isLoggedIn: Bool = false
    
    override private init() {
        super.init()
    }
    
    func activate() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    // MARK: - Actions to iOS
    func sendCompleteActivity(activityId: String) {
        WCSession.default.sendMessage(["action": "complete_activity", "activityId": activityId], replyHandler: { _ in
            print("Complete activity sent successfully")
        }) { error in
            print("Error sending message: \(error.localizedDescription)")
        }
    }
    
    func sendAttackBoss() {
        WCSession.default.sendMessage(["action": "attack_boss"], replyHandler: { _ in
            print("Attack boss sent successfully")
        }) { error in
            print("Error sending message: \(error.localizedDescription)")
        }
    }
    
    // MARK: - WCSessionDelegate
    
    nonisolated func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        Task { @MainActor in
            self.isConnected = activationState == .activated
        }
    }
    
    nonisolated func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        Task { @MainActor in
            if let isLoggedIn = applicationContext["isLoggedIn"] as? Bool {
                self.isLoggedIn = isLoggedIn
                if !isLoggedIn {
                    // Reset all other statuses
                    self.activities = []
                    self.stamina = 0
                    self.damage = 10
                    self.level = 1
                }
            }
            if let stamina = applicationContext["stamina"] as? Int {
                self.stamina = stamina
            }
            if let maxStamina = applicationContext["maxStamina"] as? Int {
                self.maxStamina = maxStamina
            }
            if let level = applicationContext["level"] as? Int {
                self.level = level
            }
            if let damage = applicationContext["damage"] as? Int {
                self.damage = damage
            }
            if let activities = applicationContext["activities"] as? [[String: Any]] {
                self.activities = activities
            }
            if let bossName = applicationContext["bossName"] as? String {
                self.bossName = bossName
            }
            if let bossCurrentHp = applicationContext["bossCurrentHp"] as? Int {
                self.bossCurrentHp = bossCurrentHp
            }
            if let bossMaxHp = applicationContext["bossMaxHp"] as? Int {
                self.bossMaxHp = bossMaxHp
            }
            if let bossIsDefeated = applicationContext["bossIsDefeated"] as? Bool {
                self.bossIsDefeated = bossIsDefeated
            }
        }
    }
    
    nonisolated func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        // Fallback for previous implementation
        session.delegate?.session?(session, didReceiveApplicationContext: userInfo)
    }
}


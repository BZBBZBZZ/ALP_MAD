//
//  WatchViewModel.swift
//  watch-os Watch App
//
//  Created by Dave on 29/05/26.
//

import Foundation

@Observable
class WatchViewModel {
    private let session = WatchSessionService.shared
    
    var stamina: Int { session.stamina }
    var maxStamina: Int { session.maxStamina }
    var damage: Int { session.damage }
    
    var activities: [[String: Any]] { session.activities }
    
    var bossName: String { session.bossName }
    var bossCurrentHp: Int { session.bossCurrentHp }
    var bossMaxHp: Int { session.bossMaxHp }
    var bossIsDefeated: Bool { session.bossIsDefeated }
    
    var isConnected: Bool { session.isConnected }
    var isLoggedIn: Bool { session.isLoggedIn }
    
    func completeActivity(id: String) {
        session.sendCompleteActivity(activityId: id)
    }
    
    func attackBoss() {
        session.sendAttackBoss()
    }
    
    var hpProgress: Double {
        guard bossMaxHp > 0 else { return 0 }
        return Double(bossCurrentHp) / Double(bossMaxHp)
    }
    
    var canAttack: Bool {
        return !bossIsDefeated && stamina >= 10
    }
}


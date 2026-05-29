//
//  UserModel.swift
//  ALP_MAD
//
//  Created by Nicholas Leroy Kurniawan on 27/5/26.
//

import Foundation

struct UserModel: Codable, Identifiable {
    var id: String
    var username: String
    var email: String
    var level: Int = 1
    var exp: Int = 0
    var expToNextLevel: Int = 100
    var damage: Int = 10
    var stamina: Int = 0
    var maxStamina: Int = 100
    var dailyStreak: Int = 0
    var totalStreak: Int = 0
    var activeBuffs: [BuffModel] = []
    var lastBossDefeatDate: String? = nil
    var totalBossesDefeated: Int = 0
    var createdAt: Date = Date()
    var isAdmin: Bool = false
    
    
    var effectiveDamage: Int {
        let damageBuffCount = activeBuffs.filter { $0.type == .damage }.count
        return Int(Double(damage) * (1.0 + 0.10 * Double(damageBuffCount)))
    }
    
    var effectiveMaxStamina: Int {
        let staminaBuffCount = activeBuffs.filter { $0.type == .stamina }.count
        return Int(Double(maxStamina) * (1.0 + 0.10 * Double(staminaBuffCount)))
    }
    
    var expProgress: Double {
        guard expToNextLevel > 0 else { return 0 }
        return Double(exp) / Double(expToNextLevel)
    }
    
    var staminaProgress: Double {
        guard effectiveMaxStamina > 0 else { return 0 }
        return Double(stamina) / Double(effectiveMaxStamina)
    }
}

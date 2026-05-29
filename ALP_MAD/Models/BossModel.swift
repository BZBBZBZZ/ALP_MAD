//
//  BossModel.swift
//  ALP_MAD
//
//  Created by Hendrawan Saputro on 29/05/26.
//

import Foundation

struct BossModel: Codable, Identifiable {
    var id: String
    var userId: String
    var bossName: String
    var maxHp: Int
    var currentHp: Int
    var spawnDate: String 
    var isDefeated: Bool = false
    var defeatCount: Int = 0
    
    var hpProgress: Double {
        guard maxHp > 0 else { return 0 }
        return Double(currentHp) / Double(maxHp)
    }
    
    var isAlive: Bool {
        return currentHp > 0 && !isDefeated
    }
}

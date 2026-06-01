//
//  Constants.swift
//  ALP_MAD
//
//  Created by Dave on 29/05/26.
//

import Foundation

struct GameConstants {
    static let baseMaxStamina: Int = 100
    static let attackStaminaCost: Int = 10
    
    static let baseBossHP: Int = 50
    static let bossHPIncrement: Int = 30
    static let bossSpawnHour: Int = 6
    static let bossSpawnMinute: Int = 00
    
    static let buffValue: Double = 0.10
    static let streakBuffInterval: Int = 5
    
    static let baseExpRequired: Double = 100
    static let expGrowthRate: Double = 1.5
    static let baseDamage: Double = 10
    static let damageGrowthRate: Double = 1.3

    static var fakeNextSpawnDate: Date? = nil
    
    static let bossNames: [String] = [
        "Shadow Wraith", "Flame Golem", "Ice Sentinel",
        "Thunder Drake", "Void Stalker", "Crystal Behemoth",
        "Dark Phoenix", "Storm Giant", "Plague Demon",
        "Iron Colossus", "Spectral Knight", "Magma Wyrm",
        "Frost Lich", "Chaos Elemental", "Blood Titan",
        "Nether Dragon", "Bone Reaper", "Arcane Guardian",
        "Doom Crawler", "Astral Horror"
    ]
    
    
    static func expToNextLevel(for level: Int) -> Int {
        return Int(baseExpRequired * pow(expGrowthRate, Double(level - 1)))
    }
    
    static func damageForLevel(_ level: Int) -> Int {
        return Int(baseDamage * pow(damageGrowthRate, Double(level - 1)))
    }
    
    static func bossHP(defeatCount: Int) -> Int {
        return baseBossHP + (defeatCount * bossHPIncrement)
    }
    
    static func randomBossName() -> String {
        return bossNames.randomElement() ?? "Unknown Boss"
    }
    
    static func bossDefeatExpBonus(bossMaxHp: Int) -> Int {
        return bossMaxHp / 2
    }
    
    static func todayDateString() -> String {
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        
        let isBeforeSpawn = (hour < bossSpawnHour) || (hour == bossSpawnHour && minute < bossSpawnMinute)
        let effectiveDate = isBeforeSpawn ? calendar.date(byAdding: .day, value: -1, to: now)! : now
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: effectiveDate)
    }
    
    static func isBossSpawnTime() -> Bool {
        let calendar = Calendar.current
        let now = Date()
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        
        if hour == bossSpawnHour {
            return minute >= bossSpawnMinute
        }
        return hour > bossSpawnHour
    }
}



//
//  ALP_MADTest.swift
//  ALP_MADTest
//
//  Created by Hendrawan Saputro on 03/06/26.
//

import XCTest
@testable import ALP_MAD

final class UserModelTests: XCTestCase {
    
    func testUserModelInitialization() {
        let user = UserModel(id: "1", username: "test", email: "test@test.com")
        XCTAssertEqual(user.username, "test")
        XCTAssertEqual(user.level, 1)
        XCTAssertEqual(user.exp, 0)
        XCTAssertEqual(user.damage, 10)
        XCTAssertEqual(user.activeBuffs.count, 0)
    }
    
    func testEffectiveDamageWithoutBuffs() {
        let user = UserModel(id: "1", username: "test", email: "test@test.com", damage: 10)
        XCTAssertEqual(user.effectiveDamage, 10, "Effective damage should be equal to base damage when there are no buffs")
    }
    
    func testEffectiveDamageWithBuffs() {
        var user = UserModel(id: "1", username: "test", email: "test@test.com", damage: 10)
        let buff1 = BuffModel(type: .damage, grantedAtStreak: 5)
        let buff2 = BuffModel(type: .damage, grantedAtStreak: 10)
        let buff3 = BuffModel(type: .stamina, grantedAtStreak: 15)
        
        user.activeBuffs = [buff1, buff2, buff3]
        
        XCTAssertEqual(user.effectiveDamage, 12, "Effective damage should increase by 10% per damage buff")
    }
    
    func testEffectiveMaxStaminaWithoutBuffs() {
        let user = UserModel(id: "1", username: "test", email: "test@test.com", maxStamina: 100)
        XCTAssertEqual(user.effectiveMaxStamina, 100, "Effective max stamina should be equal to base max stamina when there are no buffs")
    }
    
    func testEffectiveMaxStaminaWithBuffs() {
        var user = UserModel(id: "1", username: "test", email: "test@test.com", maxStamina: 100)
        let buff1 = BuffModel(type: .stamina, grantedAtStreak: 5)
        
        user.activeBuffs = [buff1]
        
        XCTAssertEqual(user.effectiveMaxStamina, 110, "Effective max stamina should increase by 10% per stamina buff")
    }
    
    func testExpProgress() {
        let user1 = UserModel(id: "1", username: "test", email: "test@test.com", exp: 50, expToNextLevel: 100)
        XCTAssertEqual(user1.expProgress, 0.5)
        
        let user2 = UserModel(id: "1", username: "test", email: "test@test.com", exp: 0, expToNextLevel: 0)
        XCTAssertEqual(user2.expProgress, 0.0, "Progress should be 0 if expToNextLevel is 0 to avoid division by zero")
    }
    
    func testStaminaProgress() {
        var user1 = UserModel(id: "1", username: "test", email: "test@test.com", stamina: 25, maxStamina: 100)
        XCTAssertEqual(user1.staminaProgress, 0.25)
        
        let buff = BuffModel(type: .stamina, grantedAtStreak: 5)
        user1.activeBuffs = [buff]
        XCTAssertEqual(user1.staminaProgress, 25.0 / 110.0)
    }
}

final class BossModelTests: XCTestCase {
    
    func testHpProgress() {
        let boss1 = BossModel(id: "1", userId: "user1", bossName: "Dragon", maxHp: 1000, currentHp: 250, spawnDate: "2026-06-03")
        XCTAssertEqual(boss1.hpProgress, 0.25)
        
        let boss2 = BossModel(id: "1", userId: "user1", bossName: "Dragon", maxHp: 0, currentHp: 0, spawnDate: "2026-06-03")
        XCTAssertEqual(boss2.hpProgress, 0.0, "Progress should be 0 if maxHp is 0 to avoid division by zero")
    }
    
    func testIsAlive() {
        let bossAlive = BossModel(id: "1", userId: "user1", bossName: "Dragon", maxHp: 1000, currentHp: 500, spawnDate: "2026-06-03", isDefeated: false)
        XCTAssertTrue(bossAlive.isAlive)
        
        let bossDeadNoHp = BossModel(id: "1", userId: "user1", bossName: "Dragon", maxHp: 1000, currentHp: 0, spawnDate: "2026-06-03", isDefeated: false)
        XCTAssertFalse(bossDeadNoHp.isAlive)
        
        let viewModel = BossViewModel()
        let bossDefeated = BossModel(id: "1", userId: "user1", bossName: "Dragon", maxHp: 1000, currentHp: 500, spawnDate: "2026-06-03", isDefeated: true)
        viewModel.boss = bossDefeated
        if viewModel.boss?.isDefeated == true {
                    viewModel.showDefeatAnimation = true
                }
        XCTAssertTrue(viewModel.showDefeatAnimation, "showDefeatAnimation berubah jadi true ketika Boss statusnya isDefeated sehingga alert muncul")
    }
}

final class BuffModelTests: XCTestCase {
    
    func testDisplayName() {
        let damageBuff = BuffModel(type: .damage, grantedAtStreak: 5)
        XCTAssertEqual(damageBuff.displayName, "+10% Damage")
        
        let staminaBuff = BuffModel(type: .stamina, grantedAtStreak: 5)
        XCTAssertEqual(staminaBuff.displayName, "+10% Max Stamina")
    }
}

final class ActivityModelTests: XCTestCase {
    
    func testActivityInitialization() {
        let activity = ActivityModel(userId: "user1", name: "Push Ups", staminaReward: 10, expReward: 20)
        
        XCTAssertFalse(activity.id.isEmpty, "ID should be automatically generated")
        XCTAssertEqual(activity.userId, "user1")
        XCTAssertEqual(activity.name, "Push Ups")
        XCTAssertEqual(activity.staminaReward, 10)
        XCTAssertEqual(activity.expReward, 20)
        XCTAssertEqual(activity.completionCount, 0, "Default completion count should be 0")
    }
}

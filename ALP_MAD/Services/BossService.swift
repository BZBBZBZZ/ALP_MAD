//
//  BossService.swift
//  ALP_MAD
//
//  Created by Hendrawan Saputro on 29/05/26.
//

import Foundation
import FirebaseFirestore

class BossService {
    static let shared = BossService()
    private let db = Firestore.firestore()
    private let collection = "bosses"
    
    private init() {}
    func getOrSpawnBoss(userId: String, currentDefeatCount: Int) async throws -> BossModel {
        let todayStr = GameConstants.todayDateString()
        
        let doc = try await db.collection(collection).document(userId).getDocument()
        
        if let data = doc.data(),
           var boss = try? Firestore.Decoder().decode(BossModel.self, from: data) {
            if boss.spawnDate == todayStr {
                return boss
            } else {
                let wasDefeated = boss.isDefeated
                let defeatCount = wasDefeated ? boss.defeatCount : boss.defeatCount
                
                let newBoss = createNewBoss(userId: userId, defeatCount: defeatCount, date: todayStr)
                try await saveBoss(newBoss)
                return newBoss
            }
        } else {
            let newBoss = createNewBoss(userId: userId, defeatCount: currentDefeatCount, date: todayStr)
            try await saveBoss(newBoss)
            return newBoss
        }
    }
    
    func checkYesterdayBossResult(userId: String) async throws -> Bool {
        let doc = try await db.collection(collection).document(userId).getDocument()
        guard let data = doc.data(),
              let boss = try? Firestore.Decoder().decode(BossModel.self, from: data) else {
            return true
        }
        
        let todayStr = GameConstants.todayDateString()
        if boss.spawnDate != todayStr && !boss.isDefeated {
            return false
        }
        return true
    }
    
    func attackBoss(userId: String, damage: Int) async throws -> BossModel {
        let doc = try await db.collection(collection).document(userId).getDocument()
        guard let data = doc.data(),
              var boss = try? Firestore.Decoder().decode(BossModel.self, from: data) else {
            throw NSError(domain: "BossService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Boss not found"])
        }
        
        guard boss.isAlive else {
            throw NSError(domain: "BossService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Boss already defeated"])
        }
        
        boss.currentHp = max(0, boss.currentHp - damage)
        
        if boss.currentHp <= 0 {
            boss.isDefeated = true
            boss.defeatCount += 1
        }
        
        try await saveBoss(boss)
        return boss
    }
    
    func saveBoss(_ boss: BossModel) async throws {
        let data = try Firestore.Encoder().encode(boss)
        try await db.collection(collection).document(boss.id).setData(data)
    }
    
    private func createNewBoss(userId: String, defeatCount: Int, date: String) -> BossModel {
        let hp = GameConstants.bossHP(defeatCount: defeatCount)
        return BossModel(
            id: userId,
            userId: userId,
            bossName: GameConstants.randomBossName(),
            maxHp: hp,
            currentHp: hp,
            spawnDate: date,
            isDefeated: false,
            defeatCount: defeatCount
        )
    }
    
    func addBossListener(userId: String, handler: @escaping (BossModel?) -> Void) -> ListenerRegistration {
        return db.collection(collection).document(userId).addSnapshotListener { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                handler(nil)
                return
            }
            let boss = try? Firestore.Decoder().decode(BossModel.self, from: data)
            handler(boss)
        }
    }
}

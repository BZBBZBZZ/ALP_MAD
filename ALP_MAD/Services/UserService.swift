//
//  UserService.swift
//  ALP_MAD
//
//  Created by Nicholas Leroy Kurniawan on 27/5/26.
//

import Foundation
import FirebaseFirestore

class UserService {
    static let shared = UserService()
    private let db = Firestore.firestore()
    private let collection = "users"
    
    private init() {}
    
    // MARK: - Create User
    func createUser(_ user: UserModel) async throws {
        let data = try Firestore.Encoder().encode(user)
        try await db.collection(collection).document(user.id).setData(data)
    }
    
    // MARK: - Get User
    func getUser(userId: String) async throws -> UserModel {
        let doc = try await db.collection(collection).document(userId).getDocument()
        guard let data = doc.data() else {
            throw NSError(domain: "UserService", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }
        return try Firestore.Decoder().decode(UserModel.self, from: data)
    }
    
    // MARK: - Update User
    func updateUser(_ user: UserModel) async throws {
        let data = try Firestore.Encoder().encode(user)
        try await db.collection(collection).document(user.id).setData(data, merge: true)
    }
    
    // MARK: - Update Username
    func updateUsername(userId: String, username: String) async throws {
        try await db.collection(collection).document(userId).updateData([
            "username": username
        ])
    }
    
    // MARK: - Update Stamina & EXP
    func addStaminaAndExp(userId: String, stamina: Int, exp: Int, user: inout UserModel) async throws {
        user.stamina = min(user.stamina + stamina, user.effectiveMaxStamina)
        user.exp += exp
        
        // Check level up
        while user.exp >= user.expToNextLevel {
            user.exp -= user.expToNextLevel
            user.level += 1
            user.damage = GameConstants.damageForLevel(user.level)
            user.expToNextLevel = GameConstants.expToNextLevel(for: user.level)
        }
        
        try await updateUser(user)
    }
    
    // MARK: - Use Stamina
    func useStamina(userId: String, amount: Int, user: inout UserModel) async throws -> Bool {
        guard user.stamina >= amount else { return false }
        user.stamina -= amount
        try await updateUser(user)
        return true
    }
    
    // MARK: - Update Streak
    func updateStreak(user: inout UserModel, won: Bool) async throws -> BuffModel? {
        var newBuff: BuffModel? = nil
        
        if won {
            user.dailyStreak += 1
            if user.dailyStreak > user.totalStreak {
                user.totalStreak = user.dailyStreak
            }
            user.lastBossDefeatDate = GameConstants.todayDateString()
            user.totalBossesDefeated += 1
            
            // Check if streak is multiple of 5 for buff
            if user.dailyStreak % GameConstants.streakBuffInterval == 0 {
                let buffType: BuffType = Bool.random() ? .damage : .stamina
                let buff = BuffModel(
                    type: buffType,
                    value: GameConstants.buffValue,
                    grantedAtStreak: user.dailyStreak
                )
                user.activeBuffs.append(buff)
                newBuff = buff
            }
        } else {
            user.dailyStreak = 0
            user.activeBuffs.removeAll()
        }
        
        try await updateUser(user)
        return newBuff
    }
    
    // MARK: - Listener
    func addUserListener(userId: String, handler: @escaping (UserModel?) -> Void) -> ListenerRegistration {
        return db.collection(collection).document(userId).addSnapshotListener { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                handler(nil)
                return
            }
            let user = try? Firestore.Decoder().decode(UserModel.self, from: data)
            handler(user)
        }
    }
}

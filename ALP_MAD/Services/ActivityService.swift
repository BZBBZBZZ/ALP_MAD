//
//  ActivityService.swift
//  ALP_MAD
//
//  Created by Dave on 29/05/26.
//

import Foundation
import FirebaseFirestore

class ActivityService {
    static let shared = ActivityService()
    private let db = Firestore.firestore()
    private let collection = "activities"
    
    private init() {}
    
    // MARK: - Create Activity
    func createActivity(_ activity: ActivityModel) async throws {
        let data = try Firestore.Encoder().encode(activity)
        try await db.collection(collection).document(activity.id).setData(data)
    }
    
    // MARK: - Get Activities for User
    func getActivities(userId: String) async throws -> [ActivityModel] {
        let snapshot = try await db.collection(collection)
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc in
            try? Firestore.Decoder().decode(ActivityModel.self, from: doc.data())
        }.sorted(by: { $0.createdAt < $1.createdAt })
    }
    
    // MARK: - Update Activity (name, staminaReward, expReward only)
    func updateActivity(_ activity: ActivityModel) async throws {
        try await db.collection(collection).document(activity.id).updateData([
            "name": activity.name,
            "staminaReward": activity.staminaReward,
            "expReward": activity.expReward
        ])
    }
    
    // MARK: - Complete Activity (increment count)
    func completeActivity(activityId: String) async throws {
        try await db.collection(collection).document(activityId).updateData([
            "completionCount": FieldValue.increment(Int64(1))
        ])
    }
    
    // MARK: - Delete Activity
    func deleteActivity(activityId: String) async throws {
        try await db.collection(collection).document(activityId).delete()
    }
    
    // MARK: - Listener
    func addActivitiesListener(userId: String, handler: @escaping ([ActivityModel]) -> Void) -> ListenerRegistration {
        return db.collection(collection)
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("ActivityListener Error: \(error.localizedDescription)")
                }
                guard let docs = snapshot?.documents, error == nil else {
                    handler([])
                    return
                }
                let activities = docs.compactMap { doc in
                    try? Firestore.Decoder().decode(ActivityModel.self, from: doc.data())
                }.sorted(by: { $0.createdAt < $1.createdAt })
                handler(activities)
            }
    }
}


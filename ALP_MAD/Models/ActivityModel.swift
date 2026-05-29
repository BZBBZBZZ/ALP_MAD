//
//  ActivityModel.swift
//  ALP_MAD
//
//  Created by Dave on 29/05/26.
//

import Foundation

struct ActivityModel: Codable, Identifiable {
    var id: String = UUID().uuidString
    var userId: String
    var name: String
    var staminaReward: Int
    var expReward: Int
    var completionCount: Int = 0
    var createdAt: Date = Date()
}

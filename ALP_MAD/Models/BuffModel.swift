//
//  BuffModel.swift
//  ALP_MAD
//
//  Created by Hendrawan Saputro on 29/05/26.
//

import Foundation

enum BuffType: String, Codable, CaseIterable {
    case damage
    case stamina
}

struct BuffModel: Codable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    var type: BuffType
    var value: Double = 0.10 
    var grantedAtStreak: Int
    
    var displayName: String {
        switch type {
        case .damage:
            return "+10% Damage"
        case .stamina:
            return "+10% Max Stamina"
        }
    }
}

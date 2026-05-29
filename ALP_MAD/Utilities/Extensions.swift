//
//  Extensions.swift
//  ALP_MAD
//
//  Created by Nicholas Leroy Kurniawan on 27/5/26.
//

import SwiftUI

extension Date {
    func toDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    func timeUntilNextSpawn() -> (hours: Int, minutes: Int, seconds: Int) {
        if let fakeSpawn = GameConstants.fakeNextSpawnDate {
            let diff = Calendar.current.dateComponents([.hour, .minute, .second], from: self, to: fakeSpawn)
            if self >= fakeSpawn {
                return (0, 0, 0)
            }
            return (diff.hour ?? 0, diff.minute ?? 0, diff.second ?? 0)
        }
        
        let calendar = Calendar.current
        let now = self
        
        var nextSpawn = calendar.date(
            bySettingHour: GameConstants.bossSpawnHour,
            minute: GameConstants.bossSpawnMinute,
            second: 0,
            of: now
        ) ?? now
        
        if nextSpawn <= now {
            nextSpawn = calendar.date(byAdding: .day, value: 1, to: nextSpawn) ?? now
        }
        
        let diff = calendar.dateComponents([.hour, .minute, .second], from: now, to: nextSpawn)
        return (diff.hour ?? 0, diff.minute ?? 0, diff.second ?? 0)
    }
}

extension Int {
    var formatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

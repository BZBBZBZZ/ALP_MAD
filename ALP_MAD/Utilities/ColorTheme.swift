//
//  ColorTheme.swift
//  ALP_MAD
//
//  Created by Nicholas Leroy Kurniawan on 27/5/26.
//

import SwiftUI

struct AppTheme {
    // MARK: - Primary
    static let primaryColor = Color(red: 108/255, green: 92/255, blue: 231/255)    // #6C5CE7
    static let secondaryColor = Color(red: 162/255, green: 155/255, blue: 254/255) // #A29BFE
    
    // MARK: - Backgrounds
    static let bgDark = Color(red: 13/255, green: 13/255, blue: 26/255)           // #0D0D1A
    static let bgCard = Color(red: 26/255, green: 26/255, blue: 46/255)           // #1A1A2E
    static let bgCardLight = Color(red: 22/255, green: 33/255, blue: 62/255)      // #16213E
    
    // MARK: - Accents
    static let accentCyan = Color(red: 0/255, green: 210/255, blue: 255/255)      // #00D2FF (Stamina)
    static let accentGold = Color(red: 243/255, green: 156/255, blue: 18/255)     // #F39C12 (EXP)
    static let accentRed = Color(red: 231/255, green: 76/255, blue: 60/255)       // #E74C3C (Boss HP)
    static let accentPink = Color(red: 253/255, green: 121/255, blue: 168/255)    // #FD79A8 (Damage)
    static let accentGreen = Color(red: 0/255, green: 206/255, blue: 148/255)     // #00CE94 (Success)
    
    // MARK: - Streak
    static let streakFire = Color(red: 255/255, green: 107/255, blue: 53/255)     // #FF6B35
    static let streakGlow = Color(red: 255/255, green: 165/255, blue: 2/255)      // #FFA502
    
    // MARK: - Text
    static let textPrimary = Color.white
    static let textSecondary = Color(red: 163/255, green: 163/255, blue: 194/255) // #A3A3C2
    static let textMuted = Color(red: 100/255, green: 100/255, blue: 130/255)     // #646482
    
    // MARK: - Gradients
    static let primaryGradient = LinearGradient(
        colors: [primaryColor, secondaryColor],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let staminaGradient = LinearGradient(
        colors: [accentCyan, Color(red: 0/255, green: 150/255, blue: 255/255)],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let expGradient = LinearGradient(
        colors: [accentGold, Color(red: 255/255, green: 200/255, blue: 50/255)],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let bossHPGradient = LinearGradient(
        colors: [accentRed, accentPink],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let attackGradient = LinearGradient(
        colors: [accentRed, Color(red: 180/255, green: 40/255, blue: 30/255)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let streakGradient = LinearGradient(
        colors: [streakFire, streakGlow],
        startPoint: .leading,
        endPoint: .trailing
    )
}

//
//  StatsDetailView.swift
//  ALP_MAD
//
//  Created by Nicholas Leroy Kurniawan on 1/6/26.
//

import SwiftUI

struct StatsDetailView: View {
    let user: UserModel
    
    var body: some View {
        VStack(spacing: 16) {
            CardView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Combat Stats")
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Divider().background(AppTheme.bgCardLight)
                    
                    statRow(icon: "⚔️", label: "Base Damage", value: "\(user.damage)", color: AppTheme.textSecondary)
                    statRow(icon: "🔥", label: "Buffed Damage", value: "\(user.effectiveDamage)", color: AppTheme.accentPink)
                    
                    Divider().background(AppTheme.bgCardLight)
                    
                    statRow(icon: "🛡️", label: "Base Max Stamina", value: "\(user.maxStamina)", color: AppTheme.textSecondary)
                    statRow(icon: "⚡", label: "Buffed Max Stamina", value: "\(user.effectiveMaxStamina)", color: AppTheme.accentCyan)
                }
            }
            
            CardView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Progression")
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Divider().background(AppTheme.bgCardLight)
                    
                    statRow(icon: "📅", label: "Daily Streak", value: "\(user.dailyStreak)", color: AppTheme.streakFire)
                    statRow(icon: "🏆", label: "All-Time Best Streak", value: "\(user.totalStreak)", color: AppTheme.accentGold)
                    
                    Divider().background(AppTheme.bgCardLight)
                    
                    statRow(icon: "👹", label: "Total Bosses Defeated", value: "\(user.totalBossesDefeated)", color: AppTheme.accentRed)
                }
            }
        }
    }
    
    private func statRow(icon: String, label: String, value: String, color: Color) -> some View {
        HStack {
            Text(icon)
                .frame(width: 24)
            Text(label)
                .font(.subheadline)
                .foregroundStyle(AppTheme.textSecondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(color)
        }
    }
}

#Preview {
    StatsDetailView(user: UserModel(id: "test", username: "Player", email: "test@test.com", level: 1, exp: 50, expToNextLevel: 100, damage: 10, stamina: 80, maxStamina: 100, dailyStreak: 5, totalStreak: 10, activeBuffs: [], lastBossDefeatDate: nil, totalBossesDefeated: 0, createdAt: Date(), isAdmin: false))
}

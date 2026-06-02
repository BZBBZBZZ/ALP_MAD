//
//  StatsBarView.swift
//  ALP_MAD
//
//  Created by Nicholas Leroy Kurniawan on 1/6/26.
//

import SwiftUI

struct StatsBarView: View {
    let user: UserModel
    
    var body: some View {
        CardView {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "sparkles")
                                .font(.caption)
                                .foregroundStyle(AppTheme.accentGold)
                            Text("EXP")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(AppTheme.accentGold)
                        }
                        
                        Spacer()
                        
                        Text("\(user.exp) / \(user.expToNextLevel)")
                            .font(.caption2)
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                    
                    ProgressBarView(
                        progress: user.expProgress,
                        gradient: AppTheme.expGradient,
                        height: 12,
                        showLabel: false
                    )
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "bolt.fill")
                                .font(.caption)
                                .foregroundStyle(AppTheme.accentCyan)
                            Text("Stamina")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(AppTheme.accentCyan)
                        }
                        
                        Spacer()
                        
                        Text("\(user.stamina) / \(user.effectiveMaxStamina)")
                            .font(.caption2)
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                    
                    ProgressBarView(
                        progress: user.staminaProgress,
                        gradient: AppTheme.staminaGradient,
                        height: 12,
                        showLabel: false
                    )
                }
            }
        }
    }
}

#Preview {
    StatsBarView(user: UserModel(id: "test", username: "Player", email: "test@test.com", level: 1, exp: 50, expToNextLevel: 100, damage: 10, stamina: 80, maxStamina: 100, dailyStreak: 5, totalStreak: 10, activeBuffs: [], lastBossDefeatDate: nil, totalBossesDefeated: 0, createdAt: Date(), isAdmin: false))
}

//
//  StreakBadgeView.swift
//  ALP_MAD
//
//  Created by Nicholas Leroy Kurniawan on 1/6/26.
//

import SwiftUI

struct StreakBadgeView: View {
    let user: UserModel
    @State private var fireAnimation = false
    
    var body: some View {
        CardView {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppTheme.streakFire.opacity(0.15))
                        .frame(width: 56, height: 56)
                    
                    Text("🔥")
                        .font(.system(size: 30))
                        .scaleEffect(fireAnimation ? 1.15 : 1.0)
                        .offset(y: fireAnimation ? -2 : 2)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Streak")
                        .font(.caption)
                        .foregroundStyle(AppTheme.textSecondary)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(user.dailyStreak)")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(AppTheme.streakGradient)
                        
                        Text(user.dailyStreak == 1 ? "day" : "days")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.textMuted)
                    }
                }
                
                Spacer()
                
                if !user.activeBuffs.isEmpty {
                    VStack(spacing: 4) {
                        Text("⚡")
                            .font(.title3)
                        Text("\(user.activeBuffs.count)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(AppTheme.accentGold)
                        Text("Buffs")
                            .font(.caption2)
                            .foregroundStyle(AppTheme.textMuted)
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(AppTheme.accentGold.opacity(0.1))
                    )
                }
            }
        }
        .onAppear {
            if user.dailyStreak > 0 {
                withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                    fireAnimation = true
                }
            }
        }
    }
}

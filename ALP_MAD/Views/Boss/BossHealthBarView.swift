//
//  BossHealthBarView.swift
//  ALP_MAD
//
//  Created by Hendrawan Saputro on 01/06/26.
//

import SwiftUI

struct BossHealthBarView: View {
    let boss: BossModel
    
    var body: some View {
        CardView {
            VStack(spacing: 8) {
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .font(.caption)
                            .foregroundStyle(AppTheme.accentRed)
                        Text("HP")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(AppTheme.accentRed)
                    }
                    
                    Spacer()
                    
                    Text("\(boss.currentHp) / \(boss.maxHp)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppTheme.textSecondary)
                        .monospacedDigit()
                }
                
                ProgressBarView(
                    progress: boss.hpProgress,
                    gradient: AppTheme.bossHPGradient,
                    height: 16,
                    showLabel: false
                )
            }
        }
    }
}

#Preview {
    BossHealthBarView(boss: BossModel(id: "1", userId: "test", bossName: "Slime", maxHp: 100, currentHp: 50, spawnDate: "2026-06-02", isDefeated: false, defeatCount: 0))
}

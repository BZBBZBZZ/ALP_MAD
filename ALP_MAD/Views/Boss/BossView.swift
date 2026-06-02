//
//  BossView.swift
//  ALP_MAD
//
//  Created by Hendrawan Saputro on 01/06/26.
//

import SwiftUI

struct BossView: View {
    let userId: String
    @State private var viewModel = BossViewModel()
    
    var body: some View {
        ZStack {
            AppTheme.bgDark.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    if let boss = viewModel.boss {
                        VStack(spacing: 6) {
                            Text("⚔️ DAILY BOSS ⚔️")
                                .font(.caption)
                                .fontWeight(.heavy)
                                .foregroundStyle(AppTheme.accentRed)
                                .tracking(3)
                            
                            Text(boss.bossName)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                        }
                        bossVisual(boss: boss)
                        
                        BossHealthBarView(boss: boss)
                        
                        if viewModel.showDamageAnimation {
                            Text("-\(viewModel.lastDamageDealt) DMG")
                                .font(.system(size: 24, weight: .heavy, design: .rounded))
                                .foregroundStyle(AppTheme.accentRed)
                                .transition(.asymmetric(
                                    insertion: .scale.combined(with: .opacity),
                                    removal: .opacity
                                ))
                        }
                        
                        AttackButtonView(
                            canAttack: viewModel.canAttack,
                            stamina: viewModel.user?.stamina ?? 0,
                            isLoading: viewModel.isLoading,
                            isDefeated: boss.isDefeated
                        ) {
                            Task { await viewModel.attackBoss() }
                        }
                        
                        CardView {
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundStyle(AppTheme.secondaryColor)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Next Boss Spawn")
                                        .font(.caption)
                                        .foregroundStyle(AppTheme.textSecondary)
                                    Text(viewModel.timeLeftString)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                        .monospacedDigit()
                                }
                                Spacer()
                            }
                        }
                        
                        if let user = viewModel.user, !user.activeBuffs.isEmpty {
                            BuffListView(buffs: user.activeBuffs)
                        }
                        
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(AppTheme.accentRed)
                                .padding()
                        }
                        
                    } else {
                        Spacer().frame(height: 200)
                        ProgressView()
                            .tint(AppTheme.primaryColor)
                            .scaleEffect(1.5)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
        }
        .onAppear {
            Task { await viewModel.loadData(userId: userId) }
        }
        .onDisappear {
            viewModel.cleanup()
        }
        .alert("Boss Defeated! 🎉", isPresented: Binding(
            get: { viewModel.showDefeatAnimation },
            set: { viewModel.showDefeatAnimation = $0 }
        )) {
            Button("OK") {
                viewModel.showDefeatAnimation = false
            }
        } message: {
            Text("You earned bonus EXP! A stronger boss awaits tomorrow.")
        }
        .alert("New Buff! ⚡", isPresented: Binding(
            get: { viewModel.showBuffAlert },
            set: { viewModel.showBuffAlert = $0 }
        )) {
            Button("Awesome!") {
                viewModel.showBuffAlert = false
            }
        } message: {
            if let buff = viewModel.newBuff {
                Text("You received: \(buff.displayName)")
            }
        }
    }
    
    private func bossVisual(boss: BossModel) -> some View {
        ZStack {
            Circle()
                .fill(AppTheme.accentRed.opacity(boss.isDefeated ? 0.05 : 0.15))
                .frame(width: 160, height: 160)
                .blur(radius: 30)
            
            Circle()
                .fill(
                    LinearGradient(
                        colors: boss.isDefeated
                            ? [Color.gray.opacity(0.3), Color.gray.opacity(0.1)]
                            : [AppTheme.accentRed.opacity(0.3), AppTheme.bgCard],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 120, height: 120)
                .overlay(
                    Circle()
                        .stroke(
                            boss.isDefeated ? Color.gray.opacity(0.3) : AppTheme.accentRed.opacity(0.5),
                            lineWidth: 3
                        )
                )
            
            Text(boss.isDefeated ? "💀" : "👹")
                .font(.system(size: 56))
                .opacity(boss.isDefeated ? 0.5 : 1.0)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    BossView(userId: "test")
}

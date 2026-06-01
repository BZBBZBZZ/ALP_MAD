//
//  HomeView.swift
//  ALP_MAD
//
//  Created by Nicholas Leroy Kurniawan on 1/6/26.
//

import SwiftUI

struct HomeView: View {
    let userId: String
    @State private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            AppTheme.bgDark.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    if let user = viewModel.user {
                        CharacterAvatarView(user: user)
                        
                        StatsBarView(user: user)
                        
                        StreakBadgeView(user: user)
                        
                        quickStatsGrid(user: user)
                        
                    } else if viewModel.isLoading {
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
            viewModel.loadUser(userId: userId)
            Task {
                await viewModel.checkDailyBossStatus(userId: userId)
            }
        }
        .onDisappear {
            viewModel.cleanup()
        }
    }
    
    private func quickStatsGrid(user: UserModel) -> some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ], spacing: 12) {
            statCard(icon: "⚔️", label: "Damage", value: "\(user.effectiveDamage)", color: AppTheme.accentPink)
            statCard(icon: "🛡️", label: "Max Stamina", value: "\(user.effectiveMaxStamina)", color: AppTheme.accentCyan)
            statCard(icon: "⭐", label: "Level", value: "\(user.level)", color: AppTheme.accentGold)
            statCard(icon: "🏆", label: "Best Streak", value: "\(user.totalStreak)", color: AppTheme.streakFire)
        }
    }
    
    private func statCard(icon: String, label: String, value: String, color: Color) -> some View {
        CardView {
            HStack(spacing: 10) {
                Text(icon)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(.caption)
                        .foregroundStyle(AppTheme.textSecondary)
                    Text(value)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(color)
                }
                
                Spacer()
            }
        }
    }
}

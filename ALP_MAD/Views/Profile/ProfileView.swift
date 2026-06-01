//
//  ProfileView.swift
//  ALP_MAD
//
//  Created by Nicholas Leroy Kurniawan on 1/6/26.
//

import SwiftUI

struct ProfileView: View {
    let userId: String
    let onLogout: () -> Void
    @State private var viewModel = ProfileViewModel()
    
    var body: some View {
        ZStack {
            AppTheme.bgDark.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    if let user = viewModel.user {
                        HStack {
                            Text("Profile")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Button {
                                viewModel.prepareEditUsername()
                            } label: {
                                Image(systemName: "pencil.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(AppTheme.primaryColor)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        
                        CardView {
                            HStack(spacing: 16) {
                                Circle()
                                    .fill(AppTheme.primaryGradient)
                                    .frame(width: 80, height: 80)
                                    .overlay(
                                        Text(String(user.username.prefix(1)).uppercased())
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white)
                                    )
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(user.username)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                    
                                    Text(user.email)
                                        .font(.subheadline)
                                        .foregroundStyle(AppTheme.textSecondary)
                                    
                                    HStack {
                                        Text("Level \(user.level)")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundStyle(AppTheme.accentGold)
                                        Text("•")
                                            .foregroundStyle(AppTheme.textMuted)
                                        Text("Joined \(user.createdAt.toDateString())")
                                            .font(.caption)
                                            .foregroundStyle(AppTheme.textMuted)
                                    }
                                    .padding(.top, 4)
                                }
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        StatsDetailView(user: user)
                            .padding(.horizontal, 16)
                        
                        if user.isAdmin {
                            CardView {
                                VStack(spacing: 12) {
                                    Text("Developer Cheats (Testing Only)")
                                        .font(.headline)
                                        .foregroundStyle(AppTheme.accentPink)
                                    
                                    VStack(spacing: 8) {
                                        Text("Override Boss Timer (Seconds)")
                                            .font(.caption)
                                            .foregroundStyle(AppTheme.textMuted)
                                        
                                        HStack {
                                            TextField("Secs", value: $viewModel.customTimerValue, format: .number)
                                                .keyboardType(.numberPad)
                                                .foregroundStyle(.white)
                                                .padding(8)
                                                .background(AppTheme.bgDark)
                                                .cornerRadius(8)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                                )
                                                .frame(width: 80)
                                            
                                            Button("Set") {
                                                GameConstants.fakeNextSpawnDate = Date().addingTimeInterval(TimeInterval(viewModel.customTimerValue))
                                            }
                                            .buttonStyle(.bordered)
                                            .tint(.orange)
                                            
                                            Button("Reset") {
                                                GameConstants.fakeNextSpawnDate = nil
                                            }
                                            .buttonStyle(.bordered)
                                            .tint(.red)
                                        }
                                    }
                                    .padding()
                                    .background(Color.black.opacity(0.1))
                                    .cornerRadius(8)
                                    
                                    Button("Add +1 Streak & Trigger Buff") {
                                        Task { await viewModel.cheatAddStreak(userId: userId) }
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(AppTheme.accentGold)
                                    
                                    Button("Instantly Kill Boss (999999 DMG)") {
                                        Task { await viewModel.cheatKillBoss(userId: userId) }
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(.green)
                                    
                                    Button("Heal boss/Spawn boss (Force Spawn)") {
                                        Task { await viewModel.cheatForceSpawnNewBoss(userId: userId) }
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(.cyan)
                                    
                                    Text("Note: Switch to Boss tab to see the effect.")
                                        .font(.caption2)
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(AppTheme.textMuted)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        GradientButtonView(
                            title: "Logout",
                            icon: "rectangle.portrait.and.arrow.right",
                            gradient: LinearGradient(
                                colors: [Color(red: 200/255, green: 50/255, blue: 50/255), Color.red],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        ) {
                            onLogout()
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        
                    } else if viewModel.isLoading {
                        Spacer().frame(height: 200)
                        ProgressView()
                            .tint(AppTheme.primaryColor)
                            .scaleEffect(1.5)
                    }
                }
                .padding(.bottom, 100)
            }
        }
        .onAppear {
            viewModel.loadUser(userId: userId)
        }
        .onDisappear {
            viewModel.cleanup()
        }
        .sheet(isPresented: $viewModel.showEditUsername) {
            EditUsernameView(viewModel: viewModel, userId: userId)
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
    }
}

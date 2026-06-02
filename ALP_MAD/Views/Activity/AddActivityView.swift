//
//  AddActivityView.swift
//  ALP_MAD
//
//  Created by Dave on 01/06/26.
//

import SwiftUI

struct AddActivityView: View {
    @Bindable var viewModel: ActivityViewModel
    let userId: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bgDark.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Title Info
                        VStack(spacing: 8) {
                            Text("New Activity")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                            Text("Create a repeatable task")
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.textSecondary)
                        }
                        .padding(.top, 20)
                        
                        // Form
                        VStack(spacing: 20) {
                            // Name
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Activity Name")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(AppTheme.textSecondary)
                                
                                TextField("e.g. Do 10 Pushups", text: $viewModel.activityName)
                                    .foregroundStyle(.white)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppTheme.bgCard)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(AppTheme.primaryColor.opacity(0.3), lineWidth: 1)
                                            )
                                    )
                            }
                            
                            // Rewards Grid
                            HStack(spacing: 16) {
                                // Stamina Reward
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "bolt.fill")
                                            .foregroundStyle(AppTheme.accentCyan)
                                        Text("Stamina Reward")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(AppTheme.textSecondary)
                                    }
                                    
                                    TextField("e.g. 5", text: $viewModel.staminaReward)
                                        .keyboardType(.numberPad)
                                        .foregroundStyle(.white)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(AppTheme.bgCard)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(AppTheme.accentCyan.opacity(0.3), lineWidth: 1)
                                                )
                                        )
                                }
                                
                                // EXP Reward
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "sparkles")
                                            .foregroundStyle(AppTheme.accentGold)
                                        Text("EXP Reward")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(AppTheme.textSecondary)
                                    }
                                    
                                    TextField("e.g. 20", text: $viewModel.expReward)
                                        .keyboardType(.numberPad)
                                        .foregroundStyle(.white)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(AppTheme.bgCard)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(AppTheme.accentGold.opacity(0.3), lineWidth: 1)
                                                )
                                        )
                                }
                            }
                            
                            if let error = viewModel.errorMessage {
                                Text(error)
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.accentRed)
                            }
                            
                            GradientButtonView(
                                title: "Create Activity",
                                icon: "plus.circle.fill",
                                isLoading: viewModel.isLoading
                            ) {
                                Task { await viewModel.addActivity(userId: userId) }
                            }
                            .padding(.top, 10)
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppTheme.bgCard.opacity(0.6))
                        )
                    }
                    .padding(.horizontal, 24)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        viewModel.clearForm()
                        dismiss()
                    }
                    .foregroundStyle(AppTheme.textSecondary)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    AddActivityView(viewModel: ActivityViewModel(), userId: "test")
}

//
//  EditActivityView.swift
//  ALP_MAD
//
//  Created by Dave on 01/06/26.
//

import SwiftUI

struct EditActivityView: View {
    @Bindable var viewModel: ActivityViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bgDark.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("Edit Activity")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                            if let act = viewModel.editingActivity {
                                Text("Completed \(act.completionCount) times")
                                    .font(.subheadline)
                                    .foregroundStyle(AppTheme.accentGreen)
                            }
                        }
                        .padding(.top, 20)
                        
                       
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Activity Name")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(AppTheme.textSecondary)
                                
                                TextField("Activity Name", text: $viewModel.activityName)
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
                            
                            
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "bolt.fill")
                                            .foregroundStyle(AppTheme.accentCyan)
                                        Text("Stamina Reward")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(AppTheme.textSecondary)
                                    }
                                    
                                    TextField("Stamina", text: $viewModel.staminaReward)
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
                                
                               
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "sparkles")
                                            .foregroundStyle(AppTheme.accentGold)
                                        Text("EXP Reward")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(AppTheme.textSecondary)
                                    }
                                    
                                    TextField("EXP", text: $viewModel.expReward)
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
                                title: "Save Changes",
                                icon: "checkmark.circle.fill",
                                isLoading: viewModel.isLoading
                            ) {
                                Task { await viewModel.updateActivity() }
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
    let vm = ActivityViewModel()
    vm.activityName = "Test"
    vm.staminaReward = "10"
    vm.expReward = "20"
    return EditActivityView(viewModel: vm)
}

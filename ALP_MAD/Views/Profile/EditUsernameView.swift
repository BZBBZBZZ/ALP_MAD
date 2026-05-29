//
//  EditUsernameView.swift
//  ALP_MAD
//
//  Created by Nicholas Leroy Kurniawan on 27/5/26.
//

import SwiftUI

struct EditUsernameView: View {
    @Bindable var viewModel: ProfileViewModel
    let userId: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bgDark.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Title Info
                    VStack(spacing: 8) {
                        Text("Edit Username")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        Text("Choose a new name for your character")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                    .padding(.top, 40)
                    
                    // Form
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("New Username")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(AppTheme.textSecondary)
                            
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundStyle(AppTheme.primaryColor)
                                    .frame(width: 20)
                                TextField("Enter new username", text: $viewModel.editUsername)
                                    .autocapitalization(.none)
                                    .foregroundStyle(.white)
                            }
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
                        
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(AppTheme.accentRed)
                                .multilineTextAlignment(.center)
                        }
                        
                        GradientButtonView(
                            title: "Save Changes",
                            icon: "checkmark.circle.fill",
                            isLoading: viewModel.isLoading
                        ) {
                            Task { await viewModel.updateUsername(userId: userId) }
                        }
                        .padding(.top, 10)
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppTheme.bgCard.opacity(0.6))
                    )
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(AppTheme.textSecondary)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

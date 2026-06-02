//
//  RegisterView.swift
//  ALP_MAD
//
//  Created by Nicholas Leroy Kurniawan on 1/6/26.
//

import SwiftUI

struct RegisterView: View {
    @Environment(AuthViewModel.self) private var authVM
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        @Bindable var authVM = authVM
        
        ZStack {
            AppTheme.bgDark.ignoresSafeArea()
            
            ZStack {
                Circle()
                    .fill(AppTheme.accentGold.opacity(0.12))
                    .frame(width: 220, height: 220)
                    .blur(radius: 60)
                    .offset(x: 100, y: -250)
                
                Circle()
                    .fill(AppTheme.primaryColor.opacity(0.1))
                    .frame(width: 200, height: 200)
                    .blur(radius: 70)
                    .offset(x: -120, y: 150)
            }
            
            ScrollView {
                VStack(spacing: 28) {
                    Spacer().frame(height: 20)
                    
                    VStack(spacing: 12) {
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 50))
                            .foregroundStyle(AppTheme.accentGold)
                            .shadow(color: AppTheme.accentGold.opacity(0.4), radius: 15)
                        
                        Text("Create Character")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        
                        Text("Begin your quest")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                    
                    VStack(spacing: 18) {
                        formField(
                            label: "Username",
                            icon: "person.fill",
                            placeholder: "Choose your character name",
                            text: $authVM.registerUsername,
                            isSecure: false
                        )
                        
                        formField(
                            label: "Email",
                            icon: "envelope.fill",
                            placeholder: "Enter your email",
                            text: $authVM.registerEmail,
                            isSecure: false
                        )
                        
                        formField(
                            label: "Password",
                            icon: "lock.fill",
                            placeholder: "Min 6 characters",
                            text: $authVM.registerPassword,
                            isSecure: true
                        )
                        
                        if let error = authVM.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(AppTheme.accentRed)
                                .multilineTextAlignment(.center)
                        }
                        
                        GradientButtonView(
                            title: "Create Account",
                            icon: "sparkles",
                            gradient: LinearGradient(
                                colors: [AppTheme.accentGold, AppTheme.streakFire],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            isLoading: authVM.isLoading
                        ) {
                            Task { await authVM.register() }
                        }
                        .padding(.top, 8)
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppTheme.bgCard.opacity(0.6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(AppTheme.accentGold.opacity(0.15), lineWidth: 1)
                            )
                    )
                    
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .foregroundStyle(AppTheme.textSecondary)
                        Button("Login") {
                            dismiss()
                        }
                        .foregroundStyle(AppTheme.secondaryColor)
                        .fontWeight(.bold)
                    }
                    .font(.subheadline)
                    
                    Spacer().frame(height: 40)
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    private func formField(
        label: String,
        icon: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(AppTheme.textSecondary)
            
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(AppTheme.accentGold.opacity(0.8))
                    .frame(width: 20)
                
                if isSecure {
                    SecureField(placeholder, text: text)
                        .foregroundStyle(.white)
                } else {
                    TextField(placeholder, text: text)
                        .autocapitalization(.none)
                        .foregroundStyle(.white)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppTheme.bgCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppTheme.accentGold.opacity(0.2), lineWidth: 1)
                    )
            )
        }
    }
}

#Preview {
    RegisterView()
        .environment(AuthViewModel())
}

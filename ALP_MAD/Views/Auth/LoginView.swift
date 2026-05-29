//
//  LoginView.swift
//  ALP_MAD
//
//  Created by Nicholas Leroy Kurniawan on 27/5/26.
//

import SwiftUI

struct LoginView: View {
    @Environment(AuthViewModel.self) private var authVM
    @State private var showRegister = false
    
    var body: some View {
        @Bindable var authVM = authVM
        
        ZStack {
            // Background
            AppTheme.bgDark.ignoresSafeArea()
            
            // Animated background orbs
            backgroundOrbs
            
            ScrollView {
                VStack(spacing: 32) {
                    Spacer().frame(height: 40)
                    
                    // Logo / Title
                    VStack(spacing: 12) {
                        Image(systemName: "shield.checkered")
                            .font(.system(size: 60))
                            .foregroundStyle(AppTheme.primaryGradient)
                            .shadow(color: AppTheme.primaryColor.opacity(0.5), radius: 20)
                        
                        Text("Quest Life")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        
                        Text("Gamify Your Daily Routine")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                    
                    // Login Form
                    VStack(spacing: 20) {
                        // Email
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(AppTheme.textSecondary)
                            
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundStyle(AppTheme.secondaryColor)
                                    .frame(width: 20)
                                TextField("Enter your email", text: $authVM.loginEmail)
                                    .textContentType(.emailAddress)
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
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
                        
                        // Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(AppTheme.textSecondary)
                            
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundStyle(AppTheme.secondaryColor)
                                    .frame(width: 20)
                                SecureField("Enter your password", text: $authVM.loginPassword)
                                    .textContentType(.password)
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
                        
                        // Error message
                        if let error = authVM.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(AppTheme.accentRed)
                                .multilineTextAlignment(.center)
                        }
                        
                        // Login Button
                        GradientButtonView(
                            title: "Login",
                            icon: "arrow.right.circle.fill",
                            isLoading: authVM.isLoading
                        ) {
                            Task { await authVM.login() }
                        }
                        .padding(.top, 8)
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppTheme.bgCard.opacity(0.6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(AppTheme.primaryColor.opacity(0.15), lineWidth: 1)
                            )
                    )
                    
                    // Register link
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundStyle(AppTheme.textSecondary)
                        Button("Register") {
                            showRegister = true
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
        .fullScreenCover(isPresented: $showRegister) {
            RegisterView()
                .environment(authVM)
        }
    }
    
    // MARK: - Background Orbs
    private var backgroundOrbs: some View {
        ZStack {
            Circle()
                .fill(AppTheme.primaryColor.opacity(0.15))
                .frame(width: 200, height: 200)
                .blur(radius: 60)
                .offset(x: -100, y: -200)
            
            Circle()
                .fill(AppTheme.secondaryColor.opacity(0.1))
                .frame(width: 250, height: 250)
                .blur(radius: 80)
                .offset(x: 120, y: 100)
            
            Circle()
                .fill(AppTheme.accentCyan.opacity(0.08))
                .frame(width: 180, height: 180)
                .blur(radius: 50)
                .offset(x: -80, y: 300)
        }
    }
}

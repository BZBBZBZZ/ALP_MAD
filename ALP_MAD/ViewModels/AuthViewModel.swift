//
//  AuthViewModel.swift
//  ALP_MAD
//
//  Created by Nicholas Leroy Kurniawan on 27/5/26.
//

import Foundation
import FirebaseAuth

@Observable
class AuthViewModel {
    var isLoggedIn: Bool = false
    var currentUserId: String?
    var isLoading: Bool = false
    var errorMessage: String?
    
    var loginEmail: String = ""
    var loginPassword: String = ""
    
    var registerUsername: String = ""
    var registerEmail: String = ""
    var registerPassword: String = ""
    
    private let authService = AuthService.shared
    private let userService = UserService.shared
    private var authListener: NSObjectProtocol?
    
    init() {
        checkAuthState()
    }
    
    func checkAuthState() {
        if let uid = authService.currentUserId {
            self.currentUserId = uid
            self.isLoggedIn = true
        }
        
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.currentUserId = user?.uid
                self?.isLoggedIn = user != nil
            }
        } as? NSObjectProtocol
    }
    
    func login() async {
        guard !loginEmail.isEmpty, !loginPassword.isEmpty else {
            errorMessage = "Please fill in all fields"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let uid = try await authService.login(email: loginEmail, password: loginPassword)
            currentUserId = uid
            isLoggedIn = true
            clearLoginFields()
            await MainActor.run {
                WatchConnectivityService.shared.syncAllDataToWatch()
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func register() async {
        guard !registerUsername.isEmpty, !registerEmail.isEmpty, !registerPassword.isEmpty else {
            errorMessage = "Please fill in all fields"
            return
        }
        
        guard registerPassword.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let uid = try await authService.register(email: registerEmail, password: registerPassword)
            
            let newUser = UserModel(
                id: uid,
                username: registerUsername,
                email: registerEmail
            )
            try await userService.createUser(newUser)
            
            currentUserId = uid
            isLoggedIn = true
            clearRegisterFields()
            await MainActor.run {
                WatchConnectivityService.shared.syncAllDataToWatch()
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func logout() {
        do {
            try authService.logout()
            isLoggedIn = false
            currentUserId = nil
            WatchConnectivityService.shared.sendAuthStatus(isLoggedIn: false)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func clearLoginFields() {
        loginEmail = ""
        loginPassword = ""
    }
    
    private func clearRegisterFields() {
        registerUsername = ""
        registerEmail = ""
        registerPassword = ""
    }
}

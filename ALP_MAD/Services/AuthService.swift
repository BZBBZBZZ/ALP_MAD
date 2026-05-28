//
//  AuthService.swift
//  ALP_MAD
//
//  Created by Nicholas Leroy Kurniawan on 27/5/26.
//

import Foundation
import FirebaseAuth

class AuthService {
    static let shared = AuthService()
    private init() {}
    
    var currentUserId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    var currentUserEmail: String? {
        return Auth.auth().currentUser?.email
    }
    
    var isLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    // MARK: - Register
    func register(email: String, password: String) async throws -> String {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return result.user.uid
    }
    
    // MARK: - Login
    func login(email: String, password: String) async throws -> String {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user.uid
    }
    
    // MARK: - Logout
    func logout() throws {
        try Auth.auth().signOut()
    }
    
    // MARK: - Auth State Listener
    func addAuthStateListener(_ handler: @escaping (String?) -> Void) -> NSObjectProtocol {
        return Auth.auth().addStateDidChangeListener { _, user in
            handler(user?.uid)
        } as! NSObjectProtocol
    }
}

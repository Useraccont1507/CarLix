//
//  AuthService.swift
//  CarLix
//
//  Create222d by Illia Verezei on 21.03.2025.
//

import Foundation
import Firebase
import FirebaseAuth

protocol AuthServiceProtocol {
    func createUser(email: String, password: String) async throws
    func signIn(email: String, password: String) async throws
    func getIsUserEnterd() -> Bool
    func deleteUser() async throws
    func getUserID() -> String
}

final class AuthService: AuthServiceProtocol {
    
    private let auth = Auth.auth()
    
    func createUser(email: String, password: String) async throws {
        try await auth.createUser(withEmail: email, password: password)
       
    }
    
    func signIn(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
       
    }
    
    func getIsUserEnterd() -> Bool {
        guard let _ = auth.currentUser else { return false }
        return true
    }
    
    func deleteUser() async throws {
        guard let user = auth.currentUser else { return }
        try await user.delete()
    }
    
    func getUserID() -> String {
        guard let uid = auth.currentUser?.uid else { return "" }
        return uid
    }
}

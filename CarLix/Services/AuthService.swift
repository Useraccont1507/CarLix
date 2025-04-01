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
    
}

final class AuthService: AuthServiceProtocol {
    private let keychainService: KeychainServiceProtocol
    private let auth = Auth.auth()
    
    init(keychainService: KeychainServiceProtocol) {
        self.keychainService = keychainService
    }
    
    func createUser(email: String, password: String) async throws {
        try await auth.createUser(withEmail: email, password: password)
        try await setUserID()
    }
    
    func signIn(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
        try await setUserID()
    }
    
    func getIsUserEnterd() -> Bool {
        guard let _ = auth.currentUser else { return false }
        return true
    }
    
    private func setUserID() async throws {
        guard let id = auth.currentUser?.uid else { return }
        try keychainService.setUserID(id: id)
    }
}

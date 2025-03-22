//
//  Storage.swift
//  CarLix
//
//  Created by Illia Verezei on 22.03.2025.
//

import Foundation
import FirebaseFirestore

protocol StorageServiceProtocol {
    func setFirstAndLastName(firstNameAndLastNames: String) async throws
}

final class StorageService: StorageServiceProtocol {
    private let keychainService: KeychainServiceProtocol
    private let db = Firestore.firestore()
    
    init(keychainService: KeychainServiceProtocol) {
        self.keychainService = keychainService
    }
    
    func setFirstAndLastName(firstNameAndLastNames: String) async throws {
        let userId = try getUserId()
        
        try await db.collection("users").document(userId).setData([
            "fullName" : firstNameAndLastNames
        ])
    }
    
    private func getUserId() throws -> String {
        return try keychainService.getUserID()
    }
}

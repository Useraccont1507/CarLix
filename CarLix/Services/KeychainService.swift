//
//  KeychainService.swift
//  CarLix
//
//  Created by Illia Verezei on 22.03.2025.
//

import Foundation
import Security

enum KeychainError: Error {
    case dataConversionError
    case itemNotFound
    case unexpectedStatus(OSStatus)
}

protocol KeychainServiceProtocol {
    func setUserID(id: String) throws
    func getUserID() throws -> String
    func deleteUserID() throws
}

final class KeychainService: KeychainServiceProtocol {
    
    private let serviceKey = "com.carlix.serviceKey"
    
    func setUserID(id: String) throws {
        guard let data = id.data(using: .utf8) else {
            throw KeychainError.dataConversionError
        }
        
        let query: [String : Any] = [
            kSecClass as String : kSecClassInternetPassword,
            kSecAttrAccount as String : serviceKey,
            kSecValueData as String : data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    func getUserID() throws -> String {
        let query: [String : Any] = [
            kSecClass as String : kSecClassInternetPassword,
            kSecAttrAccount as String: serviceKey,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecItemNotFound {
            throw KeychainError.itemNotFound
        } else if status != errSecSuccess {
            throw KeychainError.unexpectedStatus(status)
        }
        
        guard let idData = item as? Data, let id = String(data: idData, encoding: .utf8) else {
            throw KeychainError.dataConversionError
        }
        
        return id
    }
    
    func deleteUserID() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: serviceKey
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecItemNotFound {
            throw KeychainError.itemNotFound
        } else if status != errSecSuccess {
            throw KeychainError.unexpectedStatus(status)
        }
    }
}

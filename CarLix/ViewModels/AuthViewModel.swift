//
//  AuthViewModel.swift
//  CarLix
//
//  Created by Illia Verezei on 18.03.2025.
//

import Foundation

final class AuthViewModel: ObservableObject {
    private let coordinator: AuthCoordinatorProtocol?
    
    init(coordinator: AuthCoordinatorProtocol? = nil) {
        self.coordinator = coordinator
    }
    
    func moveToSignUp() {
        coordinator?.showToSignUp()
    }
    
    func moveToSignIn() {
        coordinator?.showToSignIn()
    }
}

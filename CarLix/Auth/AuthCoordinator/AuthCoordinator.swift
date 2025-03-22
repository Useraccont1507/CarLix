//
//  AuthCoordinator.swift
//  CarLix
//
//  Created by Illia Verezei on 22.03.2025.
//

import SwiftUI

protocol AuthCoordinatorProtocol: CoordinatorProtocol {
    func showToSignUp()
    func showToSignIn()
    func completeAuth()
}

final class AuthCoordinator: ObservableObject, AuthCoordinatorProtocol {
    private let appCoordinator: AppCoordinatorProtocol
    let authService: AuthServiceProtocol?
    let storageService: StorageServiceProtocol?
    
    @Published var isSignUpPresented = false
    @Published var isSignInPresented = false
    
    init(appcoordinator: AppCoordinatorProtocol, authService: AuthServiceProtocol? = nil, storageService: StorageServiceProtocol? = nil) {
        self.appCoordinator = appcoordinator
        self.authService = authService
        self.storageService = storageService
    }
    
    func start() -> AnyView {
        AnyView(AuthCoordinatorFlow(coordinator: self))
    }
    
    func showToSignUp() {
        isSignUpPresented = true
    }
    
    func showToSignIn() {
        isSignInPresented = true
    }
    
    func completeAuth() {
        isSignUpPresented = false
        isSignInPresented = false
        close()
    }
    
    private func close() {
        appCoordinator.switchToMain()
    }
    
    deinit {
        print("Auth coordinator deinit")
    }
}

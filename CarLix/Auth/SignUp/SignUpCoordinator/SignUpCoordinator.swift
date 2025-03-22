//
//  SignUpCoordinator.swift
//  CarLix
//
//  Created by Illia Verezei on 20.03.2025.
//

import SwiftUI

protocol SignUpCoordinatorProtocol: CoordinatorProtocol {
    func close()
    func moveToNameView()
}

enum SignUpViewType: Hashable {
    case name
}

final class SignUpCoordinator: ObservableObject ,SignUpCoordinatorProtocol {
    
    private weak var authCoordinator: AuthCoordinator?
    private var authService: AuthServiceProtocol?
    private var storageService: StorageServiceProtocol?
    
    @Published var navigationPath = NavigationPath()
    
    init(authCoordinator: AuthCoordinator? = nil, authService: AuthServiceProtocol? = nil, storageService: StorageServiceProtocol? = nil) {
        self.authCoordinator = authCoordinator
        self.authService = authService
        self.storageService = storageService
    }
    
    func start() -> AnyView {
        AnyView(
            SignUpCoordinatorFlow(coordinator: self, authService: authService, storageService: storageService)
        )
    }
    
    func moveToNameView() {
        navigationPath.append(SignUpViewType.name)
    }
    
    func close() {
        authCoordinator?.completeAuth()
    }
}

//
//  AppCoordinator.swift
//  CarLix
//
//  Created by Illia Verezei on 22.03.2025.
//

import SwiftUI
import FirebaseAuth

protocol CoordinatorProtocol: AnyObject {
    func start() -> AnyView
}

protocol AppCoordinatorProtocol: CoordinatorProtocol {
    func switchToAuth()
    func switchToMain()
}

enum MainViewType {
    case greeting
    case auth
    case main
}

final class AppCoordinator: ObservableObject, AppCoordinatorProtocol {
    
    let notificationService: NotificationServiceProtocol?
    let authService: AuthServiceProtocol?
    let storageService: StorageServiceProtocol?
    
    @Published var mainViewType = MainViewType.main
    
    init(notificationService: NotificationServiceProtocol? = nil, authService: AuthServiceProtocol? = nil, storageService: StorageServiceProtocol? = nil) {
        
        self.notificationService = notificationService
        self.authService = authService
        self.storageService = storageService
        
        if !UserDefaults.standard.bool(forKey: "isEntered") {
            mainViewType = .greeting
            UserDefaults.standard.set(true, forKey: "isEntered")
        } else {
            if let auth = authService, auth.getIsUserEnterd() {
                mainViewType = .main
            } else {
                mainViewType = .auth
            }
        }
    }
    
    func start() -> AnyView {
        AnyView(
            AppCoordinatorFlow(coordinator: self)
        )
    }
    
    func switchToAuth() {
        mainViewType = .auth
    }
    
    func switchToMain() {
        mainViewType = .main
    }
}

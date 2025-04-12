//
//  CarLixApp.swift
//  CarLix
//
//  Created by Illia Verezei on 17.03.2025.
//

import SwiftUI
import Firebase

@main
struct CarLixApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let notificationService = NotificationService(delegate: NotificationDelegate())
    
    var body: some Scene {
        WindowGroup {
            //FirstGreeting(viewModel: FirstGreetingViewModel(notificationService: notificationService))
            //RegisterPhoneView(viewModel: SignUpViewModel())
            if let authService = delegate.authService {
                let keychainService = delegate.keychainService // Отримуємо keychainService
                let storageService = StorageService(keychainService: keychainService!)
                let coordinator = AppCoordinator(notificationService: notificationService, authService: authService, storageService: storageService)
                coordinator.start()
            } else {
                Text("Initializing...")
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    var authService: AuthServiceProtocol?
    var keychainService: KeychainServiceProtocol! // Зробимо keychainService доступним
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        self.keychainService = KeychainService() // ініціалізація keychain
        self.authService = AuthService(keychainService: keychainService) // ініціалізація authService
        return true
    }
}

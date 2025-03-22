//
//  SignInViewModel.swift
//  CarLix
//
//  Created by Illia Verezei on 18.03.2025.
//

import Foundation

final class SignUpViewModel: ObservableObject {
    private weak var coordinator: SignUpCoordinator?
    private let authService: AuthServiceProtocol?
    private let storageService: StorageServiceProtocol?
    
    @Published var email = ""
    @Published var password = ""
    @Published var isDataCorrect = true
    @Published var userFirstAndLastName = ""
    @Published var isNameEmpty = false
    
    init(coordinator: SignUpCoordinator? = nil, authService: AuthServiceProtocol? = nil, storageService: StorageServiceProtocol? = nil) {
        self.coordinator = coordinator
        self.authService = authService
        self.storageService = storageService
    }
    
    func register() {
        guard isValidEmail(email) && !password.isEmpty else {
            isDataCorrect = false
            return
        }
        
        guard let authService = authService else { return }
        
        Task {
            do {
                try await authService.createUser(email: email, password: password)
                
                await MainActor.run {
                    coordinator?.moveToNameView()
                }
            } catch {
                print("Create user error: \(error.localizedDescription)")
                await MainActor.run {
                    isDataCorrect = false
                }
            }
        }
    }
    
    func completeRegistration() {
        if !userFirstAndLastName.isEmpty {
            Task {
                do {
                    try await storageService?.setFirstAndLastName(firstNameAndLastNames: userFirstAndLastName)
                    await MainActor.run {
                        coordinator?.close()
                    }
                } catch {
                    print("Saving error: \(error.localizedDescription)")
                }
            }
        } else {
            isNameEmpty = true
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}


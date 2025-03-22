//
//  SignInViewModel.swift
//  CarLix
//
//  Created by Illia Verezei on 22.03.2025.
//

import Foundation

final class SignInViewModel: ObservableObject {
    private weak var coordinator: AuthCoordinator?
    private let authService: AuthServiceProtocol?
    
    @Published var email = ""
    @Published var password = ""
    @Published var isDataCorrect = true
    
    init(coordinator: AuthCoordinator? = nil, authService: AuthServiceProtocol? = nil) {
        self.coordinator = coordinator
        self.authService = authService
    }
    
    func signIn() {
        if isValidEmail(email) {
            Task {
                do {
                    try await authService?.signIn(email: email, password: password)
                    
                    await MainActor.run {
                        coordinator?.completeAuth()
                    }
                } catch {
                    await MainActor.run {
                        self.isDataCorrect = false
                    }
                    print("Sign in error \(error)")
                }
            }
        } else {
            isDataCorrect = false
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return predicate.evaluate(with: email)
    }
}

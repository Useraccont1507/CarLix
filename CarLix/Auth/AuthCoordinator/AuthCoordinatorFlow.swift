//
//  AuthCoordinatorFlow.swift
//  CarLix
//
//  Created by Illia Verezei on 22.03.2025.
//

import SwiftUI

struct AuthCoordinatorFlow: View {
    @ObservedObject var coordinator: AuthCoordinator
    
    var body: some View {
        AuthView(viewModel: AuthViewModel(coordinator: coordinator))
            .sheet(isPresented: $coordinator.isSignInPresented, content: {
                let viewModel = SignInViewModel(coordinator: coordinator, authService: coordinator.authService)
                SignInView(viewModel: viewModel)
            })
            .sheet(isPresented: $coordinator.isSignUpPresented, content: {
                let signUpCoordinator = SignUpCoordinator(
                    authCoordinator: coordinator,
                    authService: coordinator.authService,
                    storageService: coordinator.storageService)
                signUpCoordinator.start()
            })
    }
}

#Preview {
    AuthCoordinatorFlow(coordinator: AuthCoordinator(appcoordinator: AppCoordinator()))
}

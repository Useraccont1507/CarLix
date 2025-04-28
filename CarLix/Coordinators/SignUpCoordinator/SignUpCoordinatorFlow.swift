//
//  SignUpCoordinatorFlow.swift
//  CarLix
//
//  Created by Illia Verezei on 20.03.2025.
//

import SwiftUI

struct SignUpCoordinatorFlow: View {
    @ObservedObject var coordinator: SignUpCoordinator
    @StateObject var viewModel: SignUpViewModel
    
    init(coordinator: SignUpCoordinator, authService: AuthServiceProtocol? = nil, storageService: StorageServiceProtocol? = nil) {
        self.coordinator = coordinator
        _viewModel = StateObject(wrappedValue: SignUpViewModel(coordinator: coordinator, authService: authService, storageService: storageService))
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            SignUpView(viewModel: viewModel)
                .navigationDestination(for: SignUpViewType.self) { path in
                    switch path {
                    case .name: NameView(viewModel: viewModel)
                    }
                }
        }
    }
}

#Preview {
    SignUpCoordinatorFlow(coordinator: SignUpCoordinator(), authService: AuthService(keychainService: KeychainService()))
}

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
    
    init(coordinator: SignUpCoordinator) {
        self.coordinator = coordinator
        _viewModel = StateObject(wrappedValue: SignUpViewModel(coordinator: coordinator))
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            RegisterPhoneView(viewModel: viewModel)
                .navigationDestination(for: SignUpViewType.self) { path in
                    switch path {
                    case .verifySMS: VerifySMSView(viewModel: viewModel)
                    case .name: NameView(viewModel: viewModel)
                    }
                }
        }
        .onAppear {
           let auth = AuthService()
            auth.verifyPhoneNumber(phoneNumber: "+380988550684") { isOk in
                print(isOk)
            }
            auth.verifySMS(smsCode: <#T##String#>, completion: <#T##(Bool) -> Void#>)
        }
    }
}

#Preview {
    SignUpCoordinatorFlow(coordinator: SignUpCoordinator())
}

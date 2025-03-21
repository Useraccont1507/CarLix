//
//  SignUpCoordinator.swift
//  CarLix
//
//  Created by Illia Verezei on 20.03.2025.
//

import SwiftUI

protocol Coordinator {
    func start() -> AnyView
}

protocol SignUpCoordinatorProtocol: Coordinator {
    func moveToVerifySMSView()
    func close()
    func moveToNameView()
}

enum SignUpViewType: Hashable {
    case verifySMS
    case name
}

final class SignUpCoordinator: ObservableObject ,SignUpCoordinatorProtocol {
    
    //private var appCoordinator
    
    @Published var navigationPath = NavigationPath()
    
    func start() -> AnyView {
        AnyView(
            SignUpCoordinatorFlow(coordinator: self)
        )
    }
    
    func moveToVerifySMSView() {
        navigationPath.append(SignUpViewType.verifySMS)
    }
    
    func moveToNameView() {
        navigationPath.append(SignUpViewType.name)
    }
    
    func close() {
        //
    }
}

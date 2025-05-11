//
//  HomeCoordinatorFlow.swift
//  CarLix
//
//  Created by Illia Verezei on 05.05.2025.
//

import Foundation
import SwiftUI

enum HomePath: Hashable {
    case profile
}

protocol HomeCoordinatorProtocol: CoordinatorProtocol {
    func moveToProfile()
    func back()
    func switchToAuth()
}

final class HomeCoordinator: HomeCoordinatorProtocol, ObservableObject {
    private weak var tabViewCoordinator: TabViewCoordinatorProtocol?
    let storageService: StorageServiceProtocol?
    let authService: AuthServiceProtocol?
    @Published var blur: CGFloat = 0
    @Published var loadingState: LoadingState = .none
    @Published var navigationPath = NavigationPath()
    
    init(storageService: StorageServiceProtocol? = nil ,tabViewCoordinator: TabViewCoordinatorProtocol? = nil, authService: AuthServiceProtocol? = nil) {
        self.storageService = storageService
        self.authService = authService
        self.tabViewCoordinator = tabViewCoordinator
    }
    
    func start() -> AnyView {
        AnyView(HomeCoordinatorFlow(coordinator: self))
    }
    
    func showLoadingView() {
        blur = 10
        loadingState = .show
    }
    func hideView() {
        blur = 0
        loadingState = .none
    }
    func moveToProfile() {
        tabViewCoordinator?.hideTabBar()
        navigationPath.append(HomePath.profile)
    }
    
    func showErrorView() {
        blur = 10
        loadingState = .error
    }
    
    func back() {
        tabViewCoordinator?.showTabBar()
        navigationPath.removeLast()
    }
    
    func switchToAuth() {
        tabViewCoordinator?.switchToAuth()
    }
}

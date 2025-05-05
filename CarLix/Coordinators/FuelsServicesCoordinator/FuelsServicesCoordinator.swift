//
//  FuelsServicesCoordinator.swift
//  CarLix
//
//  Created by Illia Verezei on 28.04.2025.
//

import SwiftUI

protocol FuelsServicesCoordinatorProtocol: CoordinatorProtocol {
    func showLoadingView()
    func hideView()
    func showErrorView()
    func showAddSuccessView()
    func showDeleteSuccessView()
    func moveToAdd()
    func back()
}

enum FuelServicePath: Hashable {
    case add
}

enum LoadingState {
    case none
    case show
    case addSuccess
    case deleteSuccess
    case error
}

final class FuelsServicesCoordinator: FuelsServicesCoordinatorProtocol, ObservableObject {
    private weak var tabViewCoordinator: TabViewCoordinatorProtocol?
    let storageService: StorageServiceProtocol?
    @Published var blur: CGFloat = 0
    @Published var loadingState: LoadingState = .none
    @Published var isFuelPresent: Bool
    @Published var navigationPath = NavigationPath()
    
    init(storageService: StorageServiceProtocol?, tabViewCoordinator: TabViewCoordinatorProtocol?, isFuelPresent: Bool) {
        self.storageService = storageService
        self.tabViewCoordinator = tabViewCoordinator
        self.isFuelPresent = isFuelPresent
    }
    
    func start() -> AnyView {
        AnyView(FuelsServicesCoordinatorFlow(coordinator: self))
    }
    
    func showLoadingView() {
        blur = 10
        loadingState = .show
    }
    func hideView() {
        blur = 0
        loadingState = .none
    }
    func moveToAdd() {
        tabViewCoordinator?.hideTabBar()
        navigationPath.append(FuelServicePath.add)
    }
    
    func showErrorView() {
        blur = 10
        loadingState = .error
    }
    
    func showAddSuccessView() {
        blur = 10
        loadingState = .addSuccess
    }
    
    func showDeleteSuccessView() {
        blur = 10
        loadingState = .deleteSuccess
    }
    
    func back() {
        tabViewCoordinator?.showTabBar()
        navigationPath.removeLast()
    }
}

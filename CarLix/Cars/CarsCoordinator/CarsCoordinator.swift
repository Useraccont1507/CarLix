//
//  CarsCoordinator.swift
//  CarLix
//
//  Created by Illia Verezei on 04.04.2025.
//

import SwiftUI

enum CarPath: Hashable {
    case add
    case edit(Car)
}

protocol CarsCoordinatorProtocol: CoordinatorProtocol {
    func callAndHideTabBar()
    func pushToAdd()
    func pushToEdit(carToEdit: Car)
    func back()
    func popToRoot()
}

class CarsCoordinator: ObservableObject, CarsCoordinatorProtocol {
    
    private weak var tabViewCoordinator: TabViewCoordinatorProtocol?
    let storageService: StorageServiceProtocol?
    
    @Published var navigationPath = NavigationPath()
    
    init(storageService: StorageServiceProtocol? = nil ,tabViewCoordinator: TabViewCoordinatorProtocol? = nil) {
        self.storageService = storageService
        self.tabViewCoordinator = tabViewCoordinator
    }
    
    func start() -> AnyView {
        AnyView(CarsCoordinatorFlow(coordinator: self))
    }
    
    func callAndHideTabBar() {
        tabViewCoordinator?.toggleTabBar()
    }
    
    func pushToAdd() {
        navigationPath.append(CarPath.add)
    }
    
    func pushToEdit(carToEdit: Car) {
        navigationPath.append(CarPath.edit(carToEdit))
    }
    
    func back() {
        navigationPath.removeLast()
    }
    
    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
}

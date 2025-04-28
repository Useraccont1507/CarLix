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
    case stats(Car)
}

protocol CarsCoordinatorProtocol: CoordinatorProtocol {
    func showTabBar()
    func hideTabBar()
    func pushToAdd()
    func pushToEdit(carToEdit: Car)
    func pushToStats(car: Car)
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
    
    func showTabBar() {
        tabViewCoordinator?.showTabBar()
    }
    
    func hideTabBar() {
        tabViewCoordinator?.hideTabBar()
    }
    
    func pushToAdd() {
        navigationPath.append(CarPath.add)
    }
    
    func pushToEdit(carToEdit: Car) {
        navigationPath.append(CarPath.edit(carToEdit))
    }
    
    func pushToStats(car: Car) {
        navigationPath.append(CarPath.stats(car))
    }
    
    func back() {
        navigationPath.removeLast()
    }
    
    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
}

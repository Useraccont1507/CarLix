//
//  TabViewCoordinator.swift
//  CarLix
//
//  Created by Illia Verezei on 02.04.2025.
//

import SwiftUI

enum Selection: String, CaseIterable {
    case home, cars, fuels, services
}

protocol TabViewCoordinatorProtocol: CoordinatorProtocol {
    func showTabBar()
    func hideTabBar()
    func changeSelection(_ selection: Selection)
    func getImageName(_ selection: Selection) -> String
}

class TabViewCoordinator: ObservableObject, TabViewCoordinatorProtocol {
    private weak var appCoordinator: AppCoordinatorProtocol?
    let storageService: StorageServiceProtocol?
    
    @Published var isTabBarPresented = true
    @Published var isUserProfilePresented = false
    @Published var selection: Selection = .cars
    
    init(appCoordinator: AppCoordinatorProtocol? = nil ,storageService: StorageServiceProtocol? = nil) {
        self.appCoordinator = appCoordinator
        self.storageService = storageService
    }
    
    func start() -> AnyView {
        AnyView(TabViewCoordinatorFlow(storageService: storageService, tabViewCoordinator: self))
    }
    
    func showTabBar() {
        isTabBarPresented = true
    }
    
    func hideTabBar() {
        isTabBarPresented = false
    }
    
    func changeSelection(_ selection: Selection) {
        self.selection = selection
    }
    
    func getImageName(_ selection: Selection) -> String {
        switch selection {
        case .home:
            "house"
        case .cars:
            "car"
        case .fuels:
            "fuelpump"
        case .services:
            "screwdriver"
        }
    }
}

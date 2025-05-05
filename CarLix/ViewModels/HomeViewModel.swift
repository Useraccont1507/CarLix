//
//  HomeViewModel.swift
//  CarLix
//
//  Created by Illia Verezei on 05.05.2025.
//

import Foundation

final class HomeViewModel: ObservableObject {
    private weak var coordinator: HomeCoordinator?
    private let storageService: StorageServiceProtocol?
    
    init(coordinator: HomeCoordinator?, storageService: StorageServiceProtocol?) {
        self.coordinator = coordinator
        self.storageService = storageService
    }
    
    func moveToProfile() {
        coordinator?.moveToProfile()
    }
}

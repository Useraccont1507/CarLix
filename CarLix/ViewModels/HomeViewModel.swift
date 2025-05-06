//
//  HomeViewModel.swift
//  CarLix
//
//  Created by Illia Verezei on 05.05.2025.
//

import Foundation

enum DateType: String, Hashable, CaseIterable {
    case day
    case week
    case month
    case year
    case all
}

final class HomeViewModel: ObservableObject {
    private weak var coordinator: HomeCoordinator?
    private let storageService: StorageServiceProtocol?
    
    @Published var cars: [Car] = []
    @Published var selectedDateType: DateType = .all
    
    init(coordinator: HomeCoordinator?, storageService: StorageServiceProtocol?) {
        self.coordinator = coordinator
        self.storageService = storageService
    }
    
    func moveToProfile() {
        coordinator?.moveToProfile()
    }
    
    func loadAllData() {
        
    }
    
    private func loadCars() {
        
    }
    
    private func loadFuelsAndServices(for: Car) {
        
    }
    
    func getCarCost(_ car: Car) -> Int {
        //TEst
        return 12000
    }
}

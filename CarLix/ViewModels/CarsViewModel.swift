//
//  CarsViewModel.swift
//  CarLix
//
//  Created by Illia Verezei on 04.04.2025.
//

import Foundation

class CarsViewModel: ObservableObject {
    private weak var carsCoordinator: CarsCoordinatorProtocol?
    private let storageService: StorageServiceProtocol?
    
    @Published var isLoadingViewPresented = false
    @Published var cars: [Car] = []
    
    init(storageService: StorageServiceProtocol? = nil, carsCoordinator: CarsCoordinatorProtocol? = nil) {
        self.carsCoordinator = carsCoordinator
        self.storageService = storageService
    }
    
    func presentFullDescription(for car: Car) {
        carsCoordinator?.pushToStats(car: car)
        carsCoordinator?.hideTabBar()
    }
    
    func moveToAdd() {
        carsCoordinator?.hideTabBar()
        carsCoordinator?.pushToAdd()
    }
    
    func loadCars() {
        isLoadingViewPresented = true
        
        guard let service = storageService else {
            print("Storage service is nil in carsVM")
            return
        }
        
        Task {
            do {
                let cars = try await service.loadCars()
                
                await MainActor.run {
                    self.cars = cars
                    isLoadingViewPresented = false
                }
            } catch {
                print("Error while loading cars: \(error.localizedDescription)")
            }
        }
    }
}

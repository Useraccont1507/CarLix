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
    private var listenTask: Task<Void, Never>?
    
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
        cars.removeAll()
        
        guard let service = storageService else {
            print("Storage service is nil in carsVM")
            return
        }
        
        listenTask?.cancel()
        
        listenTask = Task {
            for await change in service.listenCars() {
                await MainActor.run {
                    switch change {
                    case .added(let car):
                        if !cars.contains(where: { $0.id == car.id }) {
                            cars.append(car)
                        }
                    case .modified(let car):
                        if let index = cars.firstIndex(where: { $0.id == car.id }) {
                            cars[index] = car
                        }
                    case .removed(let id):
                        cars.removeAll { $0.id == id }
                    }
                  
                    cars.sort { $0.id < $1.id }
                    isLoadingViewPresented = false
                }
            }
        }
    }
    
    func stopListen() {
        listenTask = nil
        cars.removeAll()
    }
}

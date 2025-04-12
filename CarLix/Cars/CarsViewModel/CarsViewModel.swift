//
//  CarsViewModel.swift
//  CarLix
//
//  Created by Illia Verezei on 04.04.2025.
//

import Foundation

enum DeleteStatus {
    case notTapped
    case notStarted
    case started
    case error
    case successful
}

class CarsViewModel: ObservableObject {
    private weak var carsCoordinator: CarsCoordinatorProtocol?
    private let storageService: StorageServiceProtocol?
    
    @Published var blur: CGFloat = 0
    @Published var blurForFullDescription: CGFloat = 0
    @Published var isLoadingViewPresented = false
    @Published var isFullDescriprionPresented = false
    @Published var deleteStatusState = DeleteStatus.notTapped
    @Published var carToPresentFullDescription: Car?
    @Published var cars: [Car] = []
    
    init(storageService: StorageServiceProtocol? = nil, carsCoordinator: CarsCoordinatorProtocol? = nil) {
        self.carsCoordinator = carsCoordinator
        self.storageService = storageService
    }
    
    func presentFullDescription(for car: Car) {
        getCar(for: car)
        carsCoordinator?.callAndHideTabBar()
        isFullDescriprionPresented = true
    }
    
    func hideFullDescription() {
        carsCoordinator?.callAndHideTabBar()
        isFullDescriprionPresented = false
    }
    
    func moveToEdit() {
        guard let car = carToPresentFullDescription else {
            print("smth went wrong with move to edit")
            return
        }
        carsCoordinator?.pushToEdit(carToEdit: car)
    }
    
    func moveToAdd() {
        carsCoordinator?.callAndHideTabBar()
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
    
    private func getCar(for car: Car) {
        if let car = cars.last(where: { $0.id == car.id }) {
            carToPresentFullDescription = car
        }
    }
    
    func deleteCar() {
        deleteStatusState = .started
        
        Task {
            do {
                try await storageService?.deleteCar(car: carToPresentFullDescription!)
                
                await MainActor.run {
                    deleteStatusState = .successful
                    
                    loadCars()
                }
            } catch {
                print("Delete error: \(error.localizedDescription)")
                
                await MainActor.run {
                    deleteStatusState = .error
                }
            }
        }
    }
}

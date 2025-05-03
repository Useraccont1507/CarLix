//
//  FullCarDescriptionViewModel.swift
//  CarLix
//
//  Created by Illia Verezei on 26.04.2025.
//

import SwiftUI

enum DeleteStatus {
    case notTapped
    case notStarted
    case started
    case error
    case successful
}

class FullCarDescriptionViewModel: ObservableObject {
    weak private var coordinator: CarsCoordinatorProtocol?
    private let storage: StorageServiceProtocol?
    @Published var blur: CGFloat = 0
    @Published var isLoadingViewPresented = true
    @Published var deleteStatusState = DeleteStatus.notTapped
    @Published var car: Car?
    
    init(coordinator: CarsCoordinatorProtocol?, storage: StorageServiceProtocol?, car: Car?) {
        self.coordinator = coordinator
        self.storage = storage
        self.car = car
    }
    
    func loadFuelsAndServices() {
        if let car = car {
            Task {
                do {
                    async let fuels = storage?.loadFuels(for: car)
                    async let services = storage?.loadServices(for: car)

                   
                    let loadedFuels = try await fuels ?? []
                    let loadedServices = try await services ?? []

                    
                    await MainActor.run {
                        self.car?.fuels = loadedFuels
                        self.car?.services = loadedServices
                        self.isLoadingViewPresented = false
                    }
                } catch {
                    print("loading stats error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func back() {
        coordinator?.showTabBar()
        coordinator?.back()
    }
    
    func getSumCostOfFuel() -> Int {
        Int(
        car?.fuels.reduce(0, { partialResult, fuel in
            partialResult + (fuel.price ?? 0)
        }).rounded(.up) ?? 0)
    }
    
    func getSumCostOfService() -> Int {
        Int(
        car?.services.reduce(0, { partialResult, service in
            partialResult + service.price
        }).rounded(.up) ?? 0)
    }
    
    func getPeriod() -> (String, String) {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = .current
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        var firstDate = Date()
        
        if let car = car {
            let allDates = car.fuels.map { $0.date } + car.services.map { $0.date }
            if let minDate = allDates.min() {
                firstDate = minDate
            }
        }
        
        let firstDateString = dateFormatter.string(from: firstDate)
        let lastDateString = dateFormatter.string(from: Date())
        
        return (firstDateString, lastDateString)
    }
    
    func deleteServiceHistory() {
        guard let car = car else { return }
        Task {
            do {
                isLoadingViewPresented = true
                try await storage?.deleteServices(for: car)
                
                await MainActor.run {
                    loadFuelsAndServices()
                    isLoadingViewPresented = false
                }
            } catch {
                print("Error while deleting service: \(error.localizedDescription)")
                await MainActor.run {
                    isLoadingViewPresented = false
                }
            }
        }
    }
    
    func deleteFuelHistory() {
        guard let car = car else { return }
        
        
        Task {
            do {
                await MainActor.run {
                    isLoadingViewPresented = true
                }
                try await storage?.deleteFuels(for: car)
                
                await MainActor.run {
                    loadFuelsAndServices()
                    isLoadingViewPresented = false
                }
            } catch {
                print("Error while deleting fuels: \(error.localizedDescription)")
                await MainActor.run {
                    isLoadingViewPresented = false
                }
            }
        }
    }
    
    func moveToEdit() {
        guard let car = car else { return }
        
        coordinator?.pushToEdit(carToEdit: car)
    }
    
    func deleteCar() {
        guard let car = car else { return }
             
        blur = 10
        deleteStatusState = .started
        
        Task {
            do {
                try await storage?.deleteCar(car: car)
                
                await MainActor.run {
                    deleteStatusState = .successful
                    coordinator?.back()
                    coordinator?.showTabBar()
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

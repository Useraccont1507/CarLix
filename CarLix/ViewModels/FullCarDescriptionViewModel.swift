//
//  FullCarDescriptionViewModel.swift
//  CarLix
//
//  Created by Illia Verezei on 26.04.2025.
//

import SwiftUI

class FullCarDescriptionViewModel: ObservableObject {
    weak private var coordinator: CarsCoordinatorProtocol?
    private let storage: StorageServiceProtocol?
    @Published var isLoadingViewPresented = true
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
}

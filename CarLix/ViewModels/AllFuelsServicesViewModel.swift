//
//  AllFuelsViewModel.swift
//  CarLix
//
//  Created by Illia Verezei on 27.04.2025.
//

import Foundation

final class AllFuelsServicesViewModel: ObservableObject {
    private weak var coordinator: FuelsServicesCoordinatorProtocol?
    private let storage: StorageServiceProtocol?
    @Published var blur: CGFloat
    @Published var isFuelPresented: Bool
    @Published var cars: [Car] = []
    @Published var fuels: [CarFuel] = []
    @Published var services: [CarService] = []
    
    init(blur: CGFloat, isFuelPresented: Bool, coordiantor: FuelsServicesCoordinator?, storage: StorageServiceProtocol?) {
        self.blur = blur
        self.isFuelPresented = isFuelPresented
        self.coordinator = coordiantor
        self.storage = storage
        if let coordinator = coordiantor {
            coordinator.$blur
                .assign(to: &$blur)
        }
    }
    
    func loadData() {
        coordinator?.showLoadingView()
        
        self.fuels = []
        self.services = []
        Task {
            await loadDataAsync()
        }
    }
    
    private func loadDataAsync() async {
        guard let storage = storage else {
            print("Storage is nil")
            return
        }
        
        do {
            await MainActor.run {
                self.cars = []
            }
            
            try await withThrowingTaskGroup(of: Void.self) { group in
                for try await car in storage.listenCars() {
                    await MainActor.run {
                        self.cars.append(car)
                        coordinator?.hideView()
                    }
                    
                    group.addTask { [weak self] in
                        guard let self = self else { return }
                        
                        if self.isFuelPresented {
                            let fuels = try await storage.loadFuels(for: car)
                            await MainActor.run {
                                self.fuels.append(contentsOf: fuels)
                            }
                        } else {
                            let services = try await storage.loadServices(for: car)
                            await MainActor.run {
                                self.services.append(contentsOf: services)
                            }
                        }
                    }
                }
                try await group.waitForAll()
            }
        } catch {
            print("Error occured while loading data: \(error.localizedDescription)")
            await MainActor.run {
                coordinator?.hideView()
                coordinator?.showErrorView()
            }
        }
    }
    
    func showAddFuelsServices() {
        coordinator?.moveToAdd()
    }
    
    func deleteFuel(fuel: CarFuel) {
        Task {
            do {
                try await storage?.deleteOneFuel(fuel: fuel)
                
                await MainActor.run {
                    self.cars = []
                    self.fuels = []
                    self.services = []
                }
                
                await loadDataAsync()
                
                await MainActor.run {
                    coordinator?.hideView()
                    coordinator?.showDeleteSuccessView()
                }
                
            } catch {
                print("Something went wrong with delete: \(error.localizedDescription)")
                await MainActor.run {
                    coordinator?.hideView()
                    coordinator?.showErrorView()
                }
            }
        }
    }
    
    func deleteService(service: CarService) {
        Task {
            do {
                try await storage?.deleteOneService(service: service)
                
                await MainActor.run {
                    self.cars = []
                    self.fuels = []
                    self.services = []
                }
                
                await loadDataAsync()
                
                await MainActor.run {
                    coordinator?.hideView()
                    coordinator?.showDeleteSuccessView()
                }
            } catch {
                print("Something went wrong with delete: \(error.localizedDescription)")
                await MainActor.run {
                    coordinator?.hideView()
                    coordinator?.showErrorView()
                }
            }
        }
    }
}

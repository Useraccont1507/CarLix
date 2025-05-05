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
            let cars = try await storage.loadCars()
            
            await MainActor.run {
                self.cars = cars
            }
            
            await withThrowingTaskGroup(of: Void.self) { group in
                for car in cars {
                    group.addTask { [weak self] in
                        guard let self else { return }
                        
                        if self.isFuelPresented {
                            let fuels = try await storage.loadFuels(for: car)
                            for fuel in fuels {
                                await MainActor.run {
                                    self.fuels = []
                                    self.fuels.append(fuel)
                                }
                            }
                        } else {
                            let services = try await storage.loadServices(for: car)
                            for service in services {
                                await MainActor.run {
                                    self.fuels = []
                                    self.services.append(service)
                                }
                            }
                        }
                    }
                }
            }
            
            await MainActor.run {
                coordinator?.hideView()
            }
        } catch {
            print("Error occured while loading data: \(error.localizedDescription)")
            coordinator?.hideView()
            coordinator?.showErrorView()
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

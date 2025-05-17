//
//  AddFuelViewModel.swift
//  CarLix
//
//  Created by Illia Verezei on 28.04.2025.
//

import UIKit

final class AddFuelServiceViewModel: ObservableObject {
    private weak var coordinator: FuelsServicesCoordinatorProtocol?
    private let storage: StorageServiceProtocol?
    private let notificationService: NotificationServiceProtocol?
    
    @Published var blur: CGFloat
    
    @Published var isFuelAdded: Bool
    @Published var cars: [Car] = []
    @Published var carID = ""
    @Published var liters = ""
    @Published var fuelType: FuelType?
    @Published var currency = Currency.UAH
    @Published var pricePerLiter = ""
    @Published var currentMileage = ""
    @Published var stationName = ""
    @Published var stationAdress = ""
    @Published var documents: UIImage? = nil
    
    @Published var workDescription = ""
    @Published var detailedWorkDescription = ""
    @Published var price = ""
    @Published var isNotified = false
    @Published var notificationDate = Date()
    
    @Published var isImagePickerPresented = false
    
    init(blur: CGFloat, coordinator: FuelsServicesCoordinator?, storage: StorageServiceProtocol?, notificationService: NotificationServiceProtocol? ,isFuelAdded: Bool) {
        self.blur = blur
        self.coordinator = coordinator
        self.storage = storage
        self.notificationService = notificationService
        self.isFuelAdded = isFuelAdded
        if let coordinator = coordinator {
            coordinator.$blur
                .assign(to: &$blur)
        }
    }
    
    func loadCars() {
        guard let storage = storage else { return }
        
//        Task {
//            for try await car in storage.listenCars() {
//                await MainActor.run {
//                    coordinator?.hideView()
//                    self.cars.append(car)
//                    carID = car.id
//                }
//            }
//        }
    }
        
    func add() {
        
        if isFuelAdded {
            if !carID.isEmpty,
               !liters.isEmpty,
               !currentMileage.isEmpty,
               let litersInt = Int(liters),
               let mileageInt = Int(currentMileage),
               let type = fuelType,
               let car = cars.first(where: { $0.id == carID }) {
                let carFuel = CarFuel(carID: carID, liters: litersInt, fuelType: type, currency: .UAH, pricePerLiter: Float(pricePerLiter), currentMileage: mileageInt, stationName: stationName, stationAddress: stationAdress, documents: documents, date: .now)
                
                coordinator?.showLoadingView()
                
                Task {
                    do {
                        try await storage?.addFuel(fuels: carFuel, for: car)
                        
                        await MainActor.run {
                            coordinator?.showAddSuccessView()
                            self.close()
                        }
                    } catch {
                        print("Error while adding fuel: \(error.localizedDescription)")
                        
                        await MainActor.run {
                            coordinator?.showErrorView()
                        }
                    }
                }
            } else {
                coordinator?.showErrorView()
            }
        } else {
            if !carID.isEmpty,
               !price.isEmpty,
               !workDescription.isEmpty,
               !currentMileage.isEmpty,
               let priceFloat = Float(price),
               let mileageInt = Int(currentMileage),
               let car = cars.first(where: { $0.id == carID }) {
                let carService = CarService(id: UUID().uuidString, carID: carID, workDescription: workDescription, detailedDescription: detailedWorkDescription, currentMileage: mileageInt, currency: currency, price: priceFloat, stationName: stationName, stationAddress: stationAdress, documents: documents, date: .now, isNotified: isNotified, notificationDate: isNotified ? notificationDate : nil)
                
                coordinator?.showLoadingView()
                
                Task {
                    do {
                        try await storage?.addService(service: carService, for: car)
                        
                        await MainActor.run {
                            if isNotified {
                                notificationService?.setNotification(carName: car.name, toDo: workDescription, date: notificationDate)
                            }
                            print("Sussess")
                            coordinator?.showAddSuccessView()
                            self.deleteFields()
                            self.close()
                        }
                    } catch {
                        print("Error while adding service: \(error.localizedDescription)")
                        
                        await MainActor.run {
                            coordinator?.showErrorView()
                        }
                    }
                }
            } else {
                coordinator?.showErrorView()
            }
        }
    }
    
    func close() {
        coordinator?.back()
    }
    
    private func deleteFields() {
        blur = 0

        isFuelAdded = false
        cars = []
        carID = ""
        liters = ""
        fuelType = nil
        currency = .UAH
        pricePerLiter = ""
        currentMileage = ""
        stationName = ""
        stationAdress = ""
        documents = nil

        workDescription = ""
        detailedWorkDescription = ""
        price = ""
        isNotified = false
        notificationDate = Date()

        isImagePickerPresented = false
    }
}

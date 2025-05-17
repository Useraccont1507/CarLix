//
//  AddCarViewModel.swift
//  CarLix
//
//  Created by Illia Verezei on 04.04.2025.
//

import SwiftUI

enum SavingCycle {
    case notTapped
    case saveTapped
    case saved
    case notSaved
    case netwotkError
}

enum Action {
    case add
    case edit
}

final class AddEditCarViewModel: ObservableObject {
    private weak var coordinator: CarsCoordinatorProtocol?
    private let storageService: StorageServiceProtocol?
    private var carID: String?
    
    @Published var action: Action = .add
    
    @Published var isImagePickerPresented = false
    
    @Published var carName: String = ""
    @Published var carType: CarType?
    @Published var year: String = ""
    @Published var fuel: FuelType?
    @Published var engineSize: String = ""
    @Published var engineCode: String = ""
    @Published var carMileage: String = ""
    @Published var typeOfTransmission: TypeOfTransmission?
    @Published var typeOfDrive: TypeOfDrive?
    @Published var vinCode: String = ""
    @Published var photo: UIImage?
    
    @Published var savingCycle = SavingCycle.notTapped
    @Published var blur: CGFloat = 0
    
    init(coordinator: CarsCoordinatorProtocol? = nil, storageService: StorageServiceProtocol? = nil, action: Action, carToEdit: Car?) {
        self.coordinator = coordinator
        self.storageService = storageService
        self.action = action
        
        
        if let car = carToEdit, action == .edit {
            carID = car.id
            carName = car.name
            carType = car.type
            year = String(car.year)
            fuel = car.fuel
            engineSize = String(car.engineSize)
            engineCode = car.engineCode
            carMileage = String(car.carMileage)
            typeOfTransmission = car.typeOfTransmission
            typeOfDrive = car.typeOfDrive
            vinCode = car.vinCode
            photo = car.image
        }
    }
    
    func checkValuesAndSave() {
        blur = 10
        savingCycle = .saveTapped
        
        if !carName.isEmpty,
           !year.isEmpty,
           let yearNum = Int(year),
           let fuel = fuel,
           !engineSize.isEmpty,
           let sizeNum = Float(engineSize),
           !carMileage.isEmpty,
           let carMileageNum = Int(carMileage),
           let transmission = typeOfTransmission,
           let typeOfDrive = typeOfDrive {
        
            let car = Car(id: carID ?? UUID().uuidString,
                          image: photo,
                          type: carType!,
                          name: carName,
                          year: yearNum,
                          engineCode: engineCode,
                          engineSize: sizeNum,
                          fuel: fuel,
                          carMileage: carMileageNum,
                          typeOfTransmission: transmission,
                          typeOfDrive: typeOfDrive,
                          vinCode: vinCode,
                          fuels: [],
                          services: [])
            
            
            Task {
                do {
                    switch action {
                    case .add:
                        try await storageService?.setCar(car: car)
                    case .edit: 
                        try await storageService?.editCar(car: car)
                    }
                   
                    await MainActor.run {
                        savingCycle = .saved
                        coordinator?.popToRoot()
                    }
                    
                } catch {
                    print("saving car error: \(error.localizedDescription)")
                    await MainActor.run {
                        savingCycle = .netwotkError
                    }
                }
            }
        } else {
            savingCycle = .notSaved
        }
    }
    
    func close() {
        blur = 0
        coordinator?.popToRoot()
        coordinator?.showTabBar()
    }
}

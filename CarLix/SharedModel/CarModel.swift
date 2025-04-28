//
//  CarModel.swift
//  CarLix
//
//  Created by Illia Verezei on 04.04.2025.
//

import SwiftUI

enum CarType: String, CaseIterable {
    case hatchback
    case sedan
    case universal
    case liftback
    case cabrio
    case truck
    case moto
}

enum FuelType: String, CaseIterable {
    case gasoline
    case diesel
    case gas
}

enum TypeOfDrive: String, CaseIterable {
    case fwd
    case rwd
    case awd
}

enum TypeOfTransmission: String, CaseIterable {
    case manual
    case automatic
}

enum Currency: String, Hashable, CaseIterable {
    case UAH
    case USD
}

struct Car: Identifiable, Hashable {
    var id: String
    var image: UIImage?
    var type: CarType
    var name: String
    var year: Int
    var engineCode: String
    
    var engineName: String {
        String(engineSize) + " " + (!engineCode.isEmpty ? engineCode : fuel.rawValue )
    }
    
    var engineSize: Float
    var fuel: FuelType
    var carMileage: Int
    var typeOfTransmission: TypeOfTransmission
    var typeOfDrive: TypeOfDrive
    var vinCode: String
    
    var fuels: [CarFuel]
    var services: [CarService]
}

struct CarFuel: Hashable {
    var id: String = UUID().uuidString
    var carID: String
    var liters: Int
    var fuelType: FuelType
    var currency: Currency = .UAH
    var pricePerLiter: Float?
    var price: Float? {
        guard let pricePerLiter = pricePerLiter else { return nil }
        return pricePerLiter * Float(liters)
    }
    var currentMileage: Int
    var stationName: String
    var stationAddress: String
    var documents: UIImage?
    var date: Date
}

struct CarService: Hashable {
    var id: String = UUID().uuidString
    var carID: String
    var workDescription: String
    var detailedDescription: String
    var currentMileage: Int
    var currency: Currency = .USD
    var price: Float
    var stationName: String
    var stationAddress: String
    var documents: UIImage?
    var date: Date
    var isNotified: Bool
    var notificationDate: Date?
}

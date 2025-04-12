//
//  Storage.swift
//  CarLix
//
//  Created by Illia Verezei on 22.03.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

protocol StorageServiceProtocol {
    func setFirstAndLastName(firstNameAndLastNames: String) async throws
    func setCar(car: Car) async throws
    func loadCars() async throws -> [Car]
    func editCar(car: Car) async throws
    func deleteCar(car: Car) async throws
}

final class StorageService: StorageServiceProtocol {
    private let keychainService: KeychainServiceProtocol
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    init(keychainService: KeychainServiceProtocol) {
        self.keychainService = keychainService
    }
    
    func setFirstAndLastName(firstNameAndLastNames: String) async throws {
        let userId = try getUserId()
        
        try await db.collection("users").document(userId).setData([
            "fullName" : firstNameAndLastNames
        ])
    }
    
    func setCar(car: Car) async throws {
        let userID = try getUserId()
        
        let imageURL = try await saveImageAndGetURL(uiImage: car.image, carId: car.id)
        
        try await db.collection("users").document(userID).collection("cars").document(car.id).setData([
            "imageURL" : imageURL,
            "type" : car.type.rawValue,
            "name" : car.name,
            "year" : String(car.year),
            "engineCode" : car.engineCode,
            "engineSize" : String(car.engineSize),
            "fuel" : car.fuel.rawValue,
            "carMileage" : String(car.carMileage),
            "typeOfTransmission" : car.typeOfTransmission.rawValue,
            "typeOfDrive" : car.typeOfDrive.rawValue,
            "vinCode" : car.vinCode
        ])
    }
    
    func loadCars() async throws -> [Car] {
        let userID = try getUserId()
        let snapshot = try await db.collection("users").document(userID).collection("cars").getDocuments()
        
        var result: [Car] = []
        
        for doc in snapshot.documents {
            
            if let car = await generateCarFromDoc(data: doc.data(), docID: doc.documentID) {
                result.append(car)
            }
        }
        
        return result
    }
    
    func editCar(car: Car) async throws {
        var updatedData: [String : String] = [:]
        
        let userId = try getUserId()
        
        
        let oldDoc = try await db.collection("users").document(userId).collection("cars").document(car.id).getDocument()
        
        
        guard let data = oldDoc.data() else {
            return
        }
        let oldCar = await generateCarFromDoc(data: data, docID: oldDoc.documentID)
        
        guard let oldCar = oldCar else {
            return
        }
        
        if oldCar.image != car.image {
            updatedData["imageURL"] = try await saveImageAndGetURL(uiImage: car.image, carId: car.id)
        }
        
        if oldCar.type != car.type {
            print("difference")
            updatedData["type"] = car.type.rawValue
        }
        
        if oldCar.name != car.name {
            updatedData["name"] = car.name
        }
        
        if oldCar.year != car.year {
            updatedData["year"] = String(car.year)
        }
        
        if oldCar.engineCode != car.engineCode {
            updatedData["engineCode"] = car.engineCode
        }
        
        if oldCar.engineSize != car.engineSize {
            updatedData["engineSize"] = String(car.engineSize)
        }
        
        if oldCar.fuel != car.fuel {
            updatedData["fuel"] = car.fuel.rawValue
        }
        
        if oldCar.carMileage != car.carMileage {
            updatedData["fuel"] = String(car.carMileage)
        }
        
        if oldCar.typeOfTransmission != car.typeOfTransmission {
            updatedData["typeOfTransmission"] = car.typeOfTransmission.rawValue
        }
        
        if oldCar.typeOfDrive != car.typeOfDrive {
            updatedData["typeOfDrive"] = car.typeOfDrive.rawValue
        }
        
        if oldCar.vinCode != car.vinCode {
            updatedData["vinCode"] = car.vinCode
        }
        
        try await oldDoc.reference.updateData(updatedData)
    }
    
    func deleteCar(car: Car) async throws {
        let id = try getUserId()
        
        let carReference = db.collection("users").document(id).collection("cars").document(car.id)
        
        try await carReference.delete()
        
        if let imageUrlString = try await carReference.getDocument().data()?["imageURL"] as? String,
           let url = URL(string: imageUrlString) {
            try await storage.reference(for: url).delete()
        }
    }
    
    private func generateCarFromDoc(data: [String : Any], docID: String) async -> Car? {
        
        guard let imageURL = data["imageURL"] as? String else {
            print("[\(docID)] image error: \(data["type"] ?? "nil")")
            return nil
        }
        
        guard let typeRaw = data["type"] as? String,
              let type = CarType(rawValue: typeRaw) else {
            print("carType error: \(data["type"] ?? "nil")")
            return nil
        }
        
        guard let name = data["name"] as? String else {
            print("Error with name")
            return nil
        }
        
        guard let yearStr = data["year"] as? String,
              let year = Int(yearStr) else {
            print("Error with year: \(data["year"] ?? "nil")")
            return nil
        }
        
        guard let engineCode = data["engineCode"] as? String else {
            print(" Empty engineCode")
            return nil
        }
        
        guard let engineSizeStr = data["engineSize"] as? String,
              let engineSize = Float(engineSizeStr) else {
            print("Error with engineSize: \(data["engineSize"] ?? "nil")")
            return nil
        }
        
        guard let fuelRaw = data["fuel"] as? String,
              let fuel = FuelType(rawValue: fuelRaw) else {
            print("Error with fuel: \(data["fuel"] ?? "nil")")
            return nil
        }
        
        guard let mileageStr = data["carMileage"] as? String,
              let mileage = Int(mileageStr) else {
            print("Error with carMileage: \(data["carMileage"] ?? "nil")")
            return nil
        }
        
        guard let transmissionRaw = data["typeOfTransmission"] as? String,
              let transmission = TypeOfTransmission(rawValue: transmissionRaw) else {
            print("Error with typeOfTransmission: \(data["typeOfTransmission"] ?? "nil")")
            return nil
        }
        
        guard let driveRaw = data["typeOfDrive"] as? String,
              let drive = TypeOfDrive(rawValue: driveRaw) else {
            print("Error with typeOfDrive: \(data["typeOfDrive"] ?? "nil")")
            return nil
        }
        
        guard let vinCode = data["vinCode"] as? String else {
            print("Error with vinCode: \(data["vinCode"] ?? "nil")")
            return nil
        }
            
        
        return await Car(
            id: docID,
            image: try? getImageFromURL(urlString: imageURL),
            type: type,
            name: name,
            year: year,
            engineCode: engineCode,
            engineSize: engineSize,
            fuel: fuel,
            carMileage: mileage,
            typeOfTransmission: transmission,
            typeOfDrive: drive,
            vinCode: vinCode,
            fuels: [],
            services: []
        )
    }
    
    private func saveImageAndGetURL(uiImage: UIImage?, carId: String) async throws -> String {
        guard let uiImage = uiImage else {
            return ""
        }
        
        guard let imageData = uiImage.jpegData(compressionQuality: 1.0) else {
            print("Can not get data from image ")
            return ""
        }
        
        let imageRef = storage.reference().child("carImages/\(try getUserId())/\(carId)/carImage.jpg")
        
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let _ = try await imageRef.putDataAsync(imageData, metadata: metaData)
        
        return try await imageRef.downloadURL().absoluteString
    }
    
    private func getImageFromURL(urlString: String) async throws -> UIImage? {
        let ref = storage.reference(forURL: urlString)
        
        let data = try await ref.data(maxSize: 5 * 1024 * 1024)
        
        guard let image = UIImage(data: data) else {
            print("Can not get image from data")
            return nil
        }
        return image
    }
    
    private func getUserId() throws -> String {
        return try keychainService.getUserID()
    }
}

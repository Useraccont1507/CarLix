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
    func loadFuels(for car: Car) async throws -> [CarFuel]
    func addFuel(fuels: CarFuel, for car: Car) async throws
    func loadServices(for car: Car) async throws -> [CarService]
    func addService(service: CarService, for car: Car) async throws
    func deleteFuels(for car: Car) async throws
    func deleteServices(for car: Car) async throws
    func deleteOneFuel(fuel: CarFuel) async throws
    func deleteOneService(service: CarService) async throws
    func loadUserCredentails() async throws -> (String, Date)
    func changeFirstAndLastName(with value: String)  async throws
    func deleteAllUserData() async throws
}

final class StorageService: StorageServiceProtocol {
    private let authService: AuthServiceProtocol
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private let cache = NSCache<NSString, UIImage>()
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func setFirstAndLastName(firstNameAndLastNames: String) async throws {
        let userId = getUserId()
        
        try await db.collection("users").document(userId).setData([
            "name" : firstNameAndLastNames,
            "dateCreated" : Timestamp(date: .now)
        ])
    }
    
    func loadUserCredentails() async throws -> (String, Date) {
        let userId = getUserId()
        
        guard !userId.isEmpty else { return ("", .now)}
        
        let doc = try await db.collection("users").document(userId).getDocument()
        
        guard let name = doc["name"] as? String else {
            print("[\(userId)] name error: \(doc["type"] ?? "nil")")
            return ("", .now)
        }
        
        guard let dateTimestamp = doc["dateCreated"] as? Timestamp else {
            return (name, .now)
        }
        
        return (name, dateTimestamp.dateValue())
    }
    
    func setCar(car: Car) async throws {
        let userID = getUserId()
        
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
            "vinCode" : car.vinCode,
            "dateAdded" : FieldValue.serverTimestamp()
        ])
    }
    
    func loadCars() async throws -> [Car] {
        let userID = getUserId()
        
        
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
        
        let userId = getUserId()
        
        
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
            updatedData["carMileage"] = String(car.carMileage)
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
        let id = getUserId()
        
        let carReference = db.collection("users").document(id).collection("cars").document(car.id)
        
        if let imageUrlString = try await carReference.getDocument().data()?["imageURL"] as? String,
           let url = URL(string: imageUrlString) {
            try await storage.reference(for: url).delete()
        }
        
        try await deleteFuels(for: car)
        
        try await deleteServices(for: car)
        
        try await carReference.delete()
    }
    
    func deleteFuels(for car: Car) async throws {
        let id = getUserId()
        
        await withThrowingTaskGroup(of: Void.self) { group in
            for fuel in car.fuels {
                group.addTask {
                    let fuelReference = self.db.collection("users").document(id).collection("fuels").document(fuel.id)
                    try await fuelReference.delete()
                    
                    if let imageUrlString = try await fuelReference.getDocument().data()?["documentsURL"] as? String,
                       let url = URL(string: imageUrlString) {
                        try await self.storage.reference(for: url).delete()
                    }
                }
            }
        }
    }
    
    func deleteServices(for car: Car) async throws {
        let id = getUserId()
        
        await withThrowingTaskGroup(of: Void.self) { group in
            for service in car.services {
                group.addTask {
                    let serviceReference = self.db.collection("users").document(id).collection("services").document(service.id)
                    try await serviceReference.delete()
                    
                    if let imageUrlString = try await serviceReference.getDocument().data()?["documentsURL"] as? String,
                       let url = URL(string: imageUrlString) {
                        try await self.storage.reference(for: url).delete()
                    }
                }
            }
        }
    }
    
    func deleteOneFuel(fuel: CarFuel) async throws {
        let fuelReference = db.collection("users").document(getUserId()).collection("fuels").document(fuel.id)
        
        try await fuelReference.delete()
        
        if let imageUrlString = try await fuelReference.getDocument().data()?["documentsURL"] as? String,
           let url = URL(string: imageUrlString) {
            try await storage.reference(for: url).delete()
        }
    }
    
    func deleteOneService(service: CarService) async throws {
        let serviceReference = db.collection("users").document(getUserId()).collection("services").document(service.id)
        
        try await serviceReference.delete()
        
        if let imageUrlString = try await serviceReference.getDocument().data()?["document"] as? String,
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
        
        guard let dateTimestamp = data["dateAdded"] as? Timestamp else {
            return nil
        }
        
        
        return await Car(
            id: docID,
            image: try? getImageFromURLOrCache(urlString: imageURL),
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
            dateAdded: dateTimestamp.dateValue(),
            fuels: [],
            services: []
        )
    }
    
    private func generateFuelsFromDoc(data: [String : Any], docID: String) async -> CarFuel? {
        guard let carId = data["carID"] as? String,
              !carId.isEmpty else { return nil }
        
        guard let liters = data["liters"] as? Int else { return nil }
        
        guard let fuelTypeRaw = data["fuelType"] as? String,
              let fuelType = FuelType(rawValue: fuelTypeRaw) else { return nil }
        
        guard let currencyRaw = data["currency"] as? String,
              let currency = Currency(rawValue: currencyRaw) else { return nil }
        
        guard let pricePerLiter = data["pricePerLiter"] as? Float else { return nil }
        
        guard let currentMileage = data["currentMileage"] as? Int else { return nil }
        
        guard let stationName = data["stationName"] as? String else { return nil }
        
        guard let stationAdress = data["stationAdress"] as? String else { return nil }
        
        guard let documentsURL = data["documentsURL"] as? String else { return nil }
        
        guard let dateTimestamp = data["date"] as? Timestamp else {
            return nil
        }
        
        return await CarFuel(
            id: docID,
            carID: carId,
            liters: liters,
            fuelType: fuelType,
            currency: currency,
            pricePerLiter: pricePerLiter == 0 ? nil : pricePerLiter,
            currentMileage: currentMileage,
            stationName: stationName,
            stationAddress: stationAdress,
            documents: try? getImageFromURLOrCache(urlString: documentsURL),
            date: dateTimestamp.dateValue())
    }
    
    private func generateServiceFromDoc(data: [String : Any], docID: String) async -> CarService? {
        guard let carId = data["carID"] as? String,
              !carId.isEmpty else { return nil }
        
        
        guard let workDescription = data["workDescription"] as? String,
              !workDescription.isEmpty else { return nil }
        
        guard let detailedDescription = data["detailedDescription"] as? String else { return nil }
        
        guard let currentMileage = data["currentMileage"] as? Int else { return nil }
        
        guard let currencyRaw = data["currency"] as? String,
              let currency = Currency(rawValue: currencyRaw) else { return nil }
        
        guard let price = data["price"] as? Float else { return nil }
        
        guard let stationName = data["stationName"] as? String else { return nil }
        
        guard let stationAdress = data["stationAddress"] as? String else { return nil }
        
        guard let documentsURL = data["documents"] as? String else { return nil }
        
        guard let date = data["date"] as? Timestamp else { return nil }
        
        guard let isNotified = data["isNotified"] as? Bool else { return nil }
        
        return await CarService(id: docID,
                                carID: carId,
                                workDescription: workDescription, detailedDescription: detailedDescription,
                                currentMileage: currentMileage,
                                currency: currency,
                                price: price,
                                stationName: stationName,
                                stationAddress: stationAdress,
                                documents: try? getImageFromURLOrCache(urlString: documentsURL),
                                date: date.dateValue(),
                                isNotified: isNotified,
                                notificationDate: data["notificationDate"] as? Date)
    }
    
    func loadFuels(for car: Car) async throws -> [CarFuel] {
        let userID = self.getUserId()
        
        let snapshot = try await db.collection("users").document(userID).collection("fuels").getDocuments()
        
        var result: [CarFuel] = []
        
        for document in snapshot.documents {
            if let fuel = await generateFuelsFromDoc(data: document.data(), docID: document.documentID) {
                result.append(fuel)
            }
        }
        
        return result.filter({$0.carID == car.id})
    }
    
    func addFuel(fuels: CarFuel, for car: Car) async throws {
        let userID = getUserId()
        
        try await db.collection("users").document(userID).collection("fuels").document(fuels.id).setData([
            "id": fuels.id,
            "carID": car.id,
            "liters": fuels.liters,
            "fuelType": fuels.fuelType.rawValue,
            "currency": fuels.currency.rawValue,
            "pricePerLiter": fuels.pricePerLiter ?? 0,
            "currentMileage": fuels.currentMileage,
            "stationName": fuels.stationName,
            "stationAdress": fuels.stationAddress,
            "documentsURL": try await saveDocumentAndGetURL(document: fuels.documents, carId: car.id, fuelID: fuels.id, serviceID: nil),
            "date": FieldValue.serverTimestamp()
        ])
    }
    
    func loadServices(for car: Car) async throws -> [CarService] {
        let userID = self.getUserId()
        
        let snapshot = try await db.collection("users").document(userID).collection("services").getDocuments()
        
        var result: [CarService] = []
        
        for document in snapshot.documents {
            if let car = await generateServiceFromDoc(data: document.data(), docID: document.documentID) {
                result.append(car)
            }
        }
        
        return result.filter({$0.carID == car.id})
    }
    
    func addService(service: CarService, for car: Car) async throws {
        let userID = try getUserId()
        
        try await db.collection("users").document(userID).collection("services").document(service.id).setData([
            "carID": service.carID,
            "workDescription" : service.workDescription,
            "detailedDescription" : service.detailedDescription,
            "currentMileage" : service.currentMileage,
            "currency" : service.currency.rawValue,
            "price" : service.price,
            "stationName" : service.stationName,
            "stationAddress" : service.stationAddress,
            "documents" : try await saveDocumentAndGetURL(document: service.documents, carId: car.id, fuelID: nil, serviceID: service.id),
            "date" : service.date,
            "isNotified" : service.isNotified,
            "notificationDate" : service.notificationDate
        ])
    }
    
    private func saveImageAndGetURL(uiImage: UIImage?, carId: String) async throws -> String {
        guard let uiImage = uiImage else {
            return ""
        }
        
        guard let imageData = uiImage.jpegData(compressionQuality: 1.0) else {
            print("Can not get data from image ")
            return ""
        }
        
        let imageRef = storage.reference().child("carImages/\(getUserId())/\(carId)/carImage.jpg")
        
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let _ = try await imageRef.putDataAsync(imageData, metadata: metaData)
        
        let url = try await imageRef.downloadURL().absoluteString
        
        CacheManager.shared.insertImage(uiImage, forKey: url)
        
        return url
    }
    
    private func saveDocumentAndGetURL(document: UIImage?, carId: String, fuelID: String?, serviceID: String?) async throws -> String {
        guard let document = document else { return "" }
        
        guard let imageData = document.jpegData(compressionQuality: 0.1) else {
            print("Cannot get data from image")
            return ""
        }
        
        let id = fuelID ?? serviceID ?? UUID().uuidString
        
        let imageRef = storage.reference()
            .child("documents/\(getUserId())/\(carId)/\(id)/document")
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let _ = try await imageRef.putDataAsync(imageData, metadata: metaData)
        
        let url = try await imageRef.downloadURL().absoluteString
        
        CacheManager.shared.insertImage(document, forKey: url)
        
        return url
    }
    
    private func getImageFromURLOrCache(urlString: String) async throws -> UIImage? {
        if let image = CacheManager.shared.image(forKey: urlString) {
            CacheManager.shared.insertImage(image, forKey: urlString)
            return image
        } else {
            return try await getImageFromURL(urlString: urlString)
        }
    }
    
    private func getImageFromURL(urlString: String) async throws -> UIImage? {
        guard !urlString.isEmpty else { return nil }
        
        let ref = storage.reference(forURL: urlString)
        
        let data = try await ref.data(maxSize: 5 * 1024 * 1024)
        
        guard let image = UIImage(data: data) else {
            print("Can not get image from data")
            return nil
        }
        return image
    }
    
    private func getUserId() -> String {
        authService.getUserID()
    }
    
    func changeFirstAndLastName(with value: String) async throws {
        let userId = getUserId()
        
        try await db.collection("users").document(userId).updateData(["name" : value])
    }
    
    func deleteAllUserData() async throws {
        let userId = getUserId()
        
        try await db.collection("users").document(userId).delete()
    }
}

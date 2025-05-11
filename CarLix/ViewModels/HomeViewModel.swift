//
//  HomeViewModel.swift
//  CarLix
//
//  Created by Illia Verezei on 05.05.2025.
//

import Foundation

enum DateType: String, Hashable, CaseIterable {
    case day
    case week
    case month
    case year
    case all
}

enum ExpenseType: String {
    case fuel
    case service
    case none
}

struct ExpensesChartItem: Identifiable {
    var id: String = UUID().uuidString
    var expenseType: ExpenseType = .none
    var date: Date
    var price: Double
}

final class HomeViewModel: ObservableObject {
    private weak var coordinator: HomeCoordinator?
    private let storageService: StorageServiceProtocol?
    
    @Published var cars: [Car] = []
    @Published var ids: [String] = []
    @Published var selectedDateType: DateType = .all
    @Published var selectedCarForAnalytic: Car?
    @Published var selectedCarID: String?
    @Published var totalFuelServicePriceForSelectedCar: (Float, Float)?
    @Published var chartDataForSectorChart: [ExpensesChartItem] = []
    @Published var blur: CGFloat
    @Published var isNavigationActive = false
    
    init(coordinator: HomeCoordinator?, storageService: StorageServiceProtocol?) {
        self.coordinator = coordinator
        self.storageService = storageService
        self.blur = coordinator?.blur ?? 0
    }
    
    func moveToProfile() {
        isNavigationActive = true
        coordinator?.moveToProfile()
    }
    
    func loadAllData() {
        if !isNavigationActive {
            coordinator?.showLoadingView()
            
            isNavigationActive = false
            
            Task {
                guard let storage = storageService else {
                    print("Storage service is nil")
                    await MainActor.run {
                        coordinator?.hideView()
                        coordinator?.showErrorView()
                    }
                    return
                }
                
                do {
                    let cars = try await storage.loadCars()
                    
                    await MainActor.run {
                        self.cars = cars
                    }
                    
                    try await withThrowingTaskGroup(of: Void.self) { group in
                        for (index, car) in cars.enumerated() {
                            group.addTask { [weak self] in
                                guard let self = self else { return }
                                
                                do {
                                    let fuels = try await storage.loadFuels(for: car)
                                    await MainActor.run {
                                        self.cars[index].fuels.append(contentsOf: fuels)
                                    }
                                    
                                    let services = try await storage.loadServices(for: car)
                                    await MainActor.run {
                                        self.cars[index].services.append(contentsOf: services)
                                    }
                                } catch {
                                    print("Error loading data for car \(car.id): \(error.localizedDescription)")
                                }
                            }
                        }
                        
                        try await group.waitForAll()
                    }
                    
                    await MainActor.run {
                        if let car = cars.first {
                            self.selectedCarForAnalytic = car
                            self.selectedCarID = car.id
                            self.calculateCharDataForSectorChart(for: car)
                            self.caclulateDataForTotalView(for: car)
                            
                            print(car)
                        }
                        
                        coordinator?.hideView()
                    }
                    
                } catch {
                    print("Error occurred while loading cars: \(error.localizedDescription)")
                    await MainActor.run {
                        coordinator?.hideView()
                        coordinator?.showErrorView()
                    }
                }
            }
        }
    }
    
    func fitlerData(with dateType: DateType) {
        loadAllData()
        self.cars = cars.filter({ car in
            let (start, end) = getDate(from: dateType)
            let carTimestamp = Int(car.dateAdded.timeIntervalSince1970)
            return carTimestamp >= start && carTimestamp < end
        })
    }
    
    private func getDate(from: DateType) -> (Int, Int) {
        let calendar = Calendar.current
        let now = Date()

        switch from {
        case .day:
            let startOfDay = calendar.startOfDay(for: now)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            return (Int(startOfDay.timeIntervalSince1970), Int(endOfDay.timeIntervalSince1970))

        case .week:
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
            let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
            return (Int(startOfWeek.timeIntervalSince1970), Int(endOfWeek.timeIntervalSince1970))

        case .month:
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
            return (Int(startOfMonth.timeIntervalSince1970), Int(endOfMonth.timeIntervalSince1970))

        case .year:
            let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: now))!
            let endOfYear = calendar.date(byAdding: .year, value: 1, to: startOfYear)!
            return (Int(startOfYear.timeIntervalSince1970), Int(endOfYear.timeIntervalSince1970))

        case .all:
            return (0, 0)
        }
    }
    
    func calculateFuelCostFor(_ car: Car) -> Float {
        return car.fuels.map { fuel in
            if let pricePerLiter = fuel.pricePerLiter {
                return Float(fuel.liters) * pricePerLiter
            } else {
                return 0
            }
        }.reduce(0) { partialResult, price in
            partialResult + price
        }
    }

    func calculateServiceCostFor(_ car: Car) -> Float {
        car.services.reduce(0, {$0 + $1.price})
    }
    
    func calculateCarCost(_ car: Car) -> Float {
        calculateFuelCostFor(car) + calculateServiceCostFor(car)
    }
    
    func getAnalyticsDateAndCost() -> [ExpensesChartItem] {
        var result = [ExpensesChartItem]()
        
        cars.forEach { car in
            car.fuels.forEach { fuel in
                if let price = fuel.price {
                    result.append(ExpensesChartItem(expenseType: .fuel, date: fuel.date, price: Double(price)))
                }
            }
            
            car.services.forEach { service in
                result.append(ExpensesChartItem(expenseType: .service, date: service.date, price: Double(service.price)))
            }
        }
        return result
    }
    
    func calculateCharDataForSectorChart(for car: Car) {
        self.chartDataForSectorChart = [
            ExpensesChartItem(expenseType: .fuel, date: .now, price: Double(calculateFuelCostFor(car))),
            ExpensesChartItem(expenseType: .service, date: .now, price: Double(calculateServiceCostFor(car)))
        ]
    }

    func caclulateDataForTotalView(for car: Car) {
        self.totalFuelServicePriceForSelectedCar = (calculateFuelCostFor(car), calculateServiceCostFor(car))
    }
}

extension HomeViewModel {
    func updateChartAndTotalData(for car: Car) {
        let fuelCost = calculateFuelCostFor(car)
        let serviceCost = calculateServiceCostFor(car)
        
        self.chartDataForSectorChart = [
            ExpensesChartItem(expenseType: .fuel, date: .now, price: Double(fuelCost)),
            ExpensesChartItem(expenseType: .service, date: .now, price: Double(serviceCost))
        ]
        
        self.totalFuelServicePriceForSelectedCar = (fuelCost, serviceCost)
    }
}

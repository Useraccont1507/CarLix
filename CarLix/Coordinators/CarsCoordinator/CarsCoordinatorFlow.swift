//
//  CarsCoordinatorFloew.swift
//  CarLix
//
//  Created by Illia Verezei on 04.04.2025.
//

import SwiftUI

struct CarsCoordinatorFlow: View {
    @ObservedObject var coordinator: CarsCoordinator
    @StateObject var carsViewModel: CarsViewModel
    
    init(coordinator: CarsCoordinator) {
        self.coordinator = coordinator
        _carsViewModel = StateObject(wrappedValue: CarsViewModel(storageService: coordinator.storageService, carsCoordinator: coordinator))
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            CarsView(viewModel: carsViewModel)
                .navigationDestination(for: CarPath.self) { path in
                    switch path {
                    case .add: AddEditCarView(viewModel: AddEditCarViewModel(coordinator: coordinator, storageService: coordinator.storageService, action: .add, carToEdit: nil))
                    case .edit(let carToEdit): AddEditCarView(viewModel: AddEditCarViewModel(coordinator: coordinator, storageService: coordinator.storageService, action: .edit, carToEdit: carToEdit))
                    case .stats(let car):
                        FullCarDescriptionView(viewModel: FullCarDescriptionViewModel(coordinator: coordinator, storage: coordinator.storageService, car: car))
                    }
                }
        }
    }
}

#Preview {
    CarsCoordinatorFlow(coordinator: CarsCoordinator())
}

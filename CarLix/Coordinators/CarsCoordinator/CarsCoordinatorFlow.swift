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
    @StateObject var descriptionViewModel: FullCarDescriptionViewModel
    
    init(coordinator: CarsCoordinator) {
        self.coordinator = coordinator
        _carsViewModel = StateObject(wrappedValue: CarsViewModel(storageService: coordinator.storageService, carsCoordinator: coordinator))
        _descriptionViewModel = StateObject(wrappedValue: FullCarDescriptionViewModel(coordinator: coordinator, storage: coordinator.storageService, car: nil))
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            CarsView(viewModel: carsViewModel)
                .navigationDestination(for: CarPath.self) { path in
                    switch path {
                    case .add: AddEditCarView(viewModel: AddEditCarViewModel(coordinator: coordinator, storageService: coordinator.storageService, action: .add, carToEdit: nil))
                    case .edit(let carToEdit): AddEditCarView(viewModel: AddEditCarViewModel(coordinator: coordinator, storageService: coordinator.storageService, action: .edit, carToEdit: carToEdit))
                    case .stats(let car):
                        FullCarDescriptionView(viewModel: descriptionViewModel)
                            .onAppear {
                                descriptionViewModel.car = car
                            }
                    }
                }
        }
    }
}

#Preview {
    CarsCoordinatorFlow(coordinator: CarsCoordinator())
}

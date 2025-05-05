//
//  FuelsServicesCoordinatorFlow.swift
//  CarLix
//
//  Created by Illia Verezei on 28.04.2025.
//

import SwiftUI

struct FuelsServicesCoordinatorFlow: View {
    @ObservedObject var coordinator: FuelsServicesCoordinator
    @StateObject var viewModel: AllFuelsServicesViewModel
    @StateObject var addViewModel: AddFuelServiceViewModel
    
    init(coordinator: FuelsServicesCoordinator) {
        self.coordinator = coordinator
        _viewModel = StateObject(wrappedValue: AllFuelsServicesViewModel(blur: coordinator.blur, isFuelPresented: coordinator.isFuelPresent, coordiantor: coordinator, storage: coordinator.storageService))
        _addViewModel = StateObject(wrappedValue: AddFuelServiceViewModel(blur: coordinator.blur, coordinator: coordinator, storage: coordinator.storageService, isFuelAdded: coordinator.isFuelPresent))
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            AllFuelsServicesView(viewModel: viewModel)
                .navigationDestination(for: FuelServicePath.self) { item in
                    switch item {
                    case .add: AddFuelServiceView(viewModel: addViewModel)
                    }
                }
        }
        .overlay {
            ZStack {
                switch coordinator.loadingState {
                case .none:
                    EmptyView()
                case .show:
                    LoadingView()
                case .addSuccess:
                    SuccessView(coordinator: coordinator, text: "Запис був успішно доданий")
                        .transition(.asymmetric(insertion: .scale, removal: .scale))
                case .deleteSuccess:
                    SuccessView(coordinator: coordinator, text: "Запис був успішно видалений")
                        .transition(.asymmetric(insertion: .scale, removal: .scale))
                case .error:
                    ErrorView(coordinator: coordinator)
                        .transition(.asymmetric(insertion: .scale, removal: .scale))
                }
            }
            .animation(.easeIn, value: coordinator.loadingState)
        }
    }
}

#Preview {
    FuelsServicesCoordinatorFlow(coordinator: FuelsServicesCoordinator(storageService: nil, tabViewCoordinator: nil, isFuelPresent: true))
}

struct SuccessView: View {
    @ObservedObject var coordinator: FuelsServicesCoordinator
    var text: String
    
    var body: some View {
        VStack {
            Image(systemName: "checkmark")
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(.white)
                .padding()
            
            Text(text)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .padding()
            
            Button {
                coordinator.hideView()
            } label: {
                Text("ок")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.white.opacity(0.1))
                    )
            }
        }
        .padding([.top, .horizontal], 32)
        .padding(.bottom)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.1))
        )
        .padding()
    }
}

struct ErrorView: View {
    @ObservedObject var coordinator: FuelsServicesCoordinator
    
    var body: some View {
        VStack {
            Image(systemName: "xmark")
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(.white)
                .padding()
            
            Text("Упс\nЩось пішло не так\nСпробуйте пізніше")
                .multilineTextAlignment(.center)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .padding()
            
            Button {
                coordinator.hideView()
            } label: {
                Text("ок")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.white.opacity(0.1))
                    )
            }
        }
        .padding([.top, .horizontal], 32)
        .padding(.bottom)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.1))
        )
        .padding()
    }
}

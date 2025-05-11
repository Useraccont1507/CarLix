//
//  TabViewCoordinatorFlow.swift
//  CarLix
//
//  Created by Illia Verezei on 02.04.2025.
//

import SwiftUI

struct TabViewCoordinatorFlow: View {
    @ObservedObject var coordinator: TabViewCoordinator
    @StateObject var carsCoordinator: CarsCoordinator
    @StateObject var fuelsCoordinator: FuelsServicesCoordinator
    @StateObject var servicesCoordinator: FuelsServicesCoordinator
    @StateObject var homeCoordinator: HomeCoordinator
    
    init(storageService: StorageServiceProtocol?, tabViewCoordinator: TabViewCoordinator) {
        self.coordinator = tabViewCoordinator
        _carsCoordinator = StateObject(wrappedValue: CarsCoordinator(storageService: tabViewCoordinator.storageService, tabViewCoordinator: tabViewCoordinator))
        _fuelsCoordinator = StateObject(wrappedValue: FuelsServicesCoordinator(storageService: tabViewCoordinator.storageService, tabViewCoordinator: tabViewCoordinator, notificationService: tabViewCoordinator.notificationService, isFuelPresent: true))
        _servicesCoordinator = StateObject(wrappedValue: FuelsServicesCoordinator(storageService: tabViewCoordinator.storageService, tabViewCoordinator: tabViewCoordinator, notificationService: tabViewCoordinator.notificationService, isFuelPresent: false))
        _homeCoordinator = StateObject(wrappedValue: HomeCoordinator(storageService: tabViewCoordinator.storageService, tabViewCoordinator: tabViewCoordinator, authService: tabViewCoordinator.authService))
    }
    
    var body: some View {
        ZStack {
            VStack {
                switch coordinator.selection {
                case .cars:
                    carsCoordinator.start()
                case .home:
                    homeCoordinator.start()
                case .fuels:
                    fuelsCoordinator.start()
                case .services:
                    servicesCoordinator.start()
                }
            }
        }
        .overlay {
            if coordinator.isTabBarPresented {
                CustomBar(coordinator: coordinator)
                    .transition(.move(edge: .bottom))
                    .padding(.bottom, 8)
            }
        }
        .animation(.smooth(duration: 0.5, extraBounce: 0.2), value: coordinator.isTabBarPresented)
        .sheet(isPresented: $coordinator.isUserProfilePresented) {
            EmptyView()
        }
    }
}

#Preview {
    TabViewCoordinatorFlow(storageService: nil, tabViewCoordinator: TabViewCoordinator(appCoordinator: AppCoordinator(), notificationService: nil, authService: nil))
}

struct CustomBar: View {
    @ObservedObject var coordinator: TabViewCoordinator
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                HStack {
                    ForEach(Selection.allCases, id: \.self) { selection in
                        Button {
                            coordinator.changeSelection(selection)
                        } label: {
                            VStack {
                                Image(systemName: coordinator.getImageName(selection))
                                    .resizable()
                                    .frame(width: 34, height: 28)
                                    .foregroundStyle(
                                        coordinator.selection == selection ? .white : .white.opacity(0.5)
                                    )
                                
                                Text(selection.rawValue.localizedCapitalized)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(
                                        coordinator.selection == selection ? .white : .white.opacity(0.5)
                                    )
                            }
                        }
                        .frame(width: 70, height: 70)
                        .padding(.top, 6)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .cornerRadius(100)
            .padding(.horizontal)
        }
    }
}

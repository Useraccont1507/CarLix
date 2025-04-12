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
    
    init(storageService: StorageServiceProtocol?, tabViewCoordinator: TabViewCoordinator) {
        self.coordinator = tabViewCoordinator
        _carsCoordinator = StateObject(wrappedValue: CarsCoordinator(storageService: tabViewCoordinator.storageService, tabViewCoordinator: tabViewCoordinator))
    }
    
    var body: some View {
        ZStack {
            TopBar(coordinator: coordinator)
            
            switch coordinator.selection {
            case .cars:
                carsCoordinator.start()
            case .home:
                EmptyView()
            case .fuels:
                EmptyView()
            case .services:
                EmptyView()
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
    TabViewCoordinatorFlow(storageService: nil, tabViewCoordinator: TabViewCoordinator(appCoordinator: AppCoordinator()))
}

struct TopBar: View {
    @ObservedObject var coordinator: TabViewCoordinator
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    coordinator.isUserProfilePresented.toggle()
                } label: {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 26, height: 26)
                        .foregroundStyle(.white.opacity(0.5))
                        .background(
                            Circle()
                                .fill(.black.opacity(0.1))
                                .frame(width: 50, height: 50)
                        )
                }
                .frame(width: 50, height: 50)
            }
            .padding()
            
            Spacer()
        }
    }
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
            .background(
                RoundedRectangle(cornerRadius: 100)
                    .fill(.black.opacity(0.1))
                    .shadow(radius: 20)
            )
            .padding(.horizontal)
        }
    }
}

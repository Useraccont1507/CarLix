//
//  AppCoordinatorFlow.swift
//  CarLix
//
//  Created by Illia Verezei on 22.03.2025.
//

import SwiftUI

struct AppCoordinatorFlow: View {
    @ObservedObject var coordinator: AppCoordinator
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [
                Color.grayGradient,
                Color.brownGradient,
                Color.graphiteGradient,
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            switch coordinator.mainViewType {
            case .greeting:
                FirstGreeting(viewModel: FirstGreetingViewModel(coordinator: coordinator, notificationService: coordinator.notificationService))
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            case .auth:  AuthCoordinator(appcoordinator: coordinator, authService: coordinator.authService, storageService: coordinator.storageService)
                    .start()
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            case .main: TabViewCoordinator(appCoordinator: coordinator, storageService: coordinator.storageService, notificationService: coordinator.notificationService, authService: coordinator.authService)
                    .start()
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
                    .transition(.opacity)
            }
        }
        .animation(.easeIn, value: coordinator.mainViewType)
    }
}

#Preview {
    AppCoordinatorFlow(coordinator: AppCoordinator())
}

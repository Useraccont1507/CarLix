//
//  HomeCoordinatorFlow.swift
//  CarLix
//
//  Created by Illia Verezei on 05.05.2025.
//

import SwiftUI

struct HomeCoordinatorFlow: View {
    @ObservedObject var coordinator: HomeCoordinator
    @StateObject var homeViewModel: HomeViewModel
    @StateObject var profileViewModel: ProfileViewModel
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        _homeViewModel = StateObject(wrappedValue: HomeViewModel(coordinator: coordinator, storageService: coordinator.storageService))
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(homeCoordinator: coordinator, storageService: coordinator.storageService, authService: coordinator.authService))
        
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            HomeView(viewModel: homeViewModel)
                .navigationDestination(for: HomePath.self) { path in
                    switch path {
                    case .profile: ProfileView(viewModel: profileViewModel)
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
                    EmptyView()
                        .transition(.asymmetric(insertion: .scale, removal: .scale))
                case .deleteSuccess:
                    EmptyView()
                        .transition(.asymmetric(insertion: .scale, removal: .scale))
                case .error:
                    EmptyView()
                        .transition(.asymmetric(insertion: .scale, removal: .scale))
                }
            }
            .animation(.easeIn, value: coordinator.loadingState)
        }
    }
}

#Preview {
    HomeCoordinatorFlow(coordinator: HomeCoordinator())
}

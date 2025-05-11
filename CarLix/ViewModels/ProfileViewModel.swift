//
//  ProfileViewModel.swift
//  CarLix
//
//  Created by Illia Verezei on 06.05.2025.
//

import Foundation

final class ProfileViewModel: ObservableObject {
    weak private var homeCoordinator: HomeCoordinator?
    private let storageService: StorageServiceProtocol?
    private let authService: AuthServiceProtocol?
    
    @Published var isAlert = false
    @Published var isDeleteProfileAlert = false
    @Published var isPasswordAlert = false
    @Published var name: String = ""
    @Published var newName: String = ""
    @Published var dateCreatedString: String = ""
    @Published var isEditCardState = false
    @Published var blur: CGFloat
    
    init(homeCoordinator: HomeCoordinator?, storageService: StorageServiceProtocol?, authService: AuthServiceProtocol?) {
        self.homeCoordinator = homeCoordinator
        self.storageService = storageService
        self.authService = authService
        self.blur = homeCoordinator?.blur ?? 0
    }
    
    func loadUserNameAndDate() {

        homeCoordinator?.showLoadingView()

        Task {
            do {
                guard let storageService = storageService else {
                    return
                }

                let cred = try await storageService.loadUserCredentails()

                await MainActor.run {
                    self.name = cred.0
                    self.dateCreatedString = cred.1.getDateString()
                    homeCoordinator?.hideView()
                }
            } catch {
                await MainActor.run {
                    homeCoordinator?.hideView()
                    homeCoordinator?.showErrorView()
                }
            }
        }
    }

    
    func editName() {
        homeCoordinator?.showLoadingView()
        
        Task {
            do {
                try await storageService?.changeFirstAndLastName(with: newName)
                
               await MainActor.run {
                   loadUserNameAndDate()
                    isEditCardState = false
                    newName = ""
                   homeCoordinator?.hideView()
                }
            } catch {
                print("Edit name error: \(error.localizedDescription)")
                await MainActor.run {
                    homeCoordinator?.hideView()
                    homeCoordinator?.showErrorView()
                }
            }
        }
    }
    
    func deleteProfile() {
        homeCoordinator?.showLoadingView()
        
        Task {
            do {
                try await storageService?.deleteAllUserData()
                try await authService?.deleteUser()
                
                await MainActor.run {
                    homeCoordinator?.switchToAuth()
                }
            } catch {
                print("Delete account error occured: \(error.localizedDescription)")
                
                await MainActor.run {
                    homeCoordinator?.showErrorView()
                }
            }
        }
    }
    
    func exit() {
        homeCoordinator?.showLoadingView()
        homeCoordinator?.switchToAuth()
        homeCoordinator?.showErrorView()
    }
    
    func back() {
        homeCoordinator?.back()
    }
}

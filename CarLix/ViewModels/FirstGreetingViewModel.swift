//
//  FirstGreetingViewModel.swift
//  CarLix
//
//  Created by Illia Verezei on 17.03.2025.
//

import Foundation

enum GreetingStep {
    case begin
    case addCar
    case addFuelingAndService
    case carHistory
    case receiveNotification
    case end
}

final class FirstGreetingViewModel: ObservableObject {
    private weak var coordinator: AppCoordinatorProtocol?
    private let notificationService: NotificationServiceProtocol?
    
    @Published var greetingStep: GreetingStep = .begin
    @Published var notificationAlertState = false
    @Published var notificationDismissedAlertState = false
    @Published var blur: CGFloat = 0
    
    init(coordinator: AppCoordinator, notificationService: NotificationServiceProtocol? = nil) {
        self.coordinator = coordinator
        self.notificationService = notificationService
    }
    
    func nextStep() {
        switch greetingStep {
        case .begin:
            greetingStep = .addCar
        case .addCar:
            greetingStep = .addFuelingAndService
        case .addFuelingAndService:
            greetingStep = .carHistory
        case .carHistory:
            greetingStep = .receiveNotification
        case .receiveNotification:
            
            if notificationAlertState {
                requestNotification { [weak self] isAllowed in
                    guard let self = self else { return }
                    
                    DispatchQueue.main.async {
                        if isAllowed {
                            self.notificationAlertState = false
                            self.blur = 0
                            self.greetingStep = .end
                        } else {
                            self.notificationAlertState = false
                            self.notificationDismissedAlertState = true
                        }
                    }
                }
            } else if notificationDismissedAlertState {
                notificationDismissedAlertState = false
                blur = 0
                greetingStep = .end
            } else {
                blur = 20
                notificationAlertState = true
            }
            
        case .end:
            coordinator?.switchToAuth()
        }
    }
    
    func requestNotification(completion: @escaping ((Bool) -> Void)) {
        notificationService?.makeRequest { completion($0) }
    }
}

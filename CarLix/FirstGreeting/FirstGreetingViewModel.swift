//
//  FirstGreetingViewModel.swift
//  CarLix
//
//  Created by Illia Verezei on 17.03.2025.
//

import Foundation

final class FirstGreetingViewModel: ObservableObject {
    private var notificationService: NotificationServiceProtocol?
    
    @Published var greetingStep: GreetingStep = .begin
    @Published var notificationAlertState = false
    @Published var notificationDismissedAlertState = false
    
    init(notificationService: NotificationServiceProtocol? = nil) {
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
                            self.greetingStep = .end
                        } else {
                            self.notificationAlertState = false
                            self.notificationDismissedAlertState = true
                        }
                    }
                }
            } else if notificationDismissedAlertState {
                notificationDismissedAlertState = false
                greetingStep = .end
            } else {
                notificationAlertState = true
            }
            
        case .end:
            print("Ended")
        }
    }
    
    func requestNotification(completion: @escaping ((Bool) -> Void)) {
        notificationService?.makeRequest { completion($0) }
    }
}

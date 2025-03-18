//
//  FirstGreetingViewModel.swift
//  CarLix
//
//  Created by Illia Verezei on 17.03.2025.
//

import Foundation

final class FirstGreetingViewModel: ObservableObject {
    @Published var greetingStep: GreetingStep = .begin
    @Published var notificationAlertState = false
    @Published var notificationDismissedAlertState = false
    
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
                requestNotification { isGranted in
                    if isGranted {
                        greetingStep = .end
                    } else {
                        notificationAlertState = false
                        notificationDismissedAlertState = true
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
    
    func requestNotification(completion: ((Bool) -> Void)) {
        //service
        completion(false)
    }
}

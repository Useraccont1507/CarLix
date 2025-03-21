//
//  SignInViewModel.swift
//  CarLix
//
//  Created by Illia Verezei on 18.03.2025.
//

import Foundation

final class SignUpViewModel: ObservableObject {
    private let coordinator: SignUpCoordinator?
    
    
    @Published var phoneNumber: String = ""
    @Published var isPhoneIsIncorrectOrUsed = false
    @Published var isSMSSended = true
    @Published var SMSCode: [String] = ["", "", "", "", "", ""]
    @Published var isSmsCodeCorrect = true
    @Published var userFirstAndLastName = ""
    @Published var isNameEmpty = false
    
    init(coordinator: SignUpCoordinator? = nil) {
        self.coordinator = coordinator
    }
    
    func checkPhoneNumberAndSendSMS() {
       //Checking
        coordinator?.moveToVerifySMSView()
    }
    
    func checkSMS() {
        //Checking
        moveToNameView()
    }
    
    private func moveToNameView() {
        coordinator?.moveToNameView()
    }
    
    func completeRegistration() {
        if !userFirstAndLastName.isEmpty {
            isNameEmpty = false
        } else {
            isNameEmpty = true
        }
    }
}


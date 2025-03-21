//
//  SignUpView.swift
//  CarLix
//
//  Created by Illia Verezei on 18.03.2025.
//

import SwiftUI

struct RegisterPhoneView: View {
    @State private var fixedScreenHeight: CGFloat? = nil
    @ObservedObject var viewModel: SignUpViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("SigningUp")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.darkGreyText)
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("PhoneNumber")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.darkGreyText)
                    .padding(.leading, 8)
                
                TextField("", text: $viewModel.phoneNumber)
                    .keyboardType(.phonePad)
                    .font(.system(size: 24, weight: .semibold))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(viewModel.isPhoneIsIncorrectOrUsed ? .red : .mint, lineWidth: 2)
                            .foregroundStyle(.white)
                            .shadow(color: viewModel.isPhoneIsIncorrectOrUsed ? .red : .mint, radius: 20, x: 0, y: 2)
                        
                    )
                
                if viewModel.isPhoneIsIncorrectOrUsed {
                    Text("NumberIsUsed")
                        .font(.system(size: 14, weight: .regular))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.red)
                        .padding(.leading, 8)
                }
                
                Text("PhoneNumberRequirments")
                    .font(.system(size: 14, weight: .regular))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(viewModel.isPhoneIsIncorrectOrUsed ? .red : .gray)
                    .padding(.leading, 8)
                
            }
            .padding(.bottom)
            
            Button {
                viewModel.checkPhoneNumberAndSendSMS()
            } label: {
                Text("SendSMS")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .padding()
                    .padding(.horizontal)
            }
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .foregroundStyle(.mint)
            )
            .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            
        }
        .padding()
    }
}

#Preview {
    RegisterPhoneView(viewModel: SignUpViewModel())
}

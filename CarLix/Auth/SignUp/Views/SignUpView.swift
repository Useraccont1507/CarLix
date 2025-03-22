//
//  SignUpView.swift
//  CarLix
//
//  Created by Illia Verezei on 22.03.2025.
//

import SwiftUI

struct SignUpView: View {
    
    @ObservedObject var viewModel: SignUpViewModel
    
    var body: some View {
        VStack {
            Text("SigningUp")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.darkGreyText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            VStack {
                Text("Email")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.darkGreyText)
                    .padding(.leading, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("", text: $viewModel.email)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .font(.system(size: 24, weight: .semibold))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(viewModel.isDataCorrect ? .mint : .red, lineWidth: 2)
                            .foregroundStyle(.white)
                            .shadow(color: viewModel.isDataCorrect ? .mint : .red, radius: 20, x: 0, y: 2)
                        
                    )
                    .padding(.bottom)
                
                Text("Password")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.darkGreyText)
                    .padding(.leading, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("", text: $viewModel.password)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.default)
                    .font(.system(size: 24, weight: .semibold))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(viewModel.isDataCorrect ? .mint : .red, lineWidth: 2)
                            .foregroundStyle(.white)
                            .shadow(color: viewModel.isDataCorrect ? .mint : .red, radius: 20, x: 0, y: 2)
                        
                    )
                Text("PasswordRequirements")
                    .font(.system(size: 14, weight: .regular))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(viewModel.isDataCorrect ? .gray : .red)
                    .padding(.leading, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                if !viewModel.isDataCorrect {
                    Text("EmailOrPasswordAreWrong")
                        .font(.system(size: 14, weight: .regular))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.red)
                        .padding(.leading, 8)
                }
                    
            }
            .padding(.bottom)
            
            Button {
                viewModel.register()
            } label: {
                Text("Register")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .padding()
                    .padding(.horizontal)
            }
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .foregroundStyle(.mint)
            )
            
            Spacer()
        }
        .padding()
        
    }
}

#Preview {
    SignUpView(viewModel: SignUpViewModel())
}

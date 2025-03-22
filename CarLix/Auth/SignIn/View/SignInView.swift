//
//  SignInView.swift
//  CarLix
//
//  Created by Illia Verezei on 22.03.2025.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel: SignInViewModel
    
    var body: some View {
        VStack {
            Text("SigningIn")
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
            }
            
            VStack {
                Text("Password")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.darkGreyText)
                    .padding(.leading, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("", text: $viewModel.password)
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
                viewModel.signIn()
            } label: {
                Text("SignIn")
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
    SignInView(viewModel: SignInViewModel())
}

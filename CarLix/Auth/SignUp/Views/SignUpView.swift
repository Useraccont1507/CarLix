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
        ZStack {
            LinearGradient(colors: [
                Color.gray,
                Color.brown,
                Color.gray,
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack {
                VStack {
                    HStack {
                        Text("SigningUp")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        Button {
                            viewModel.close()
                        } label: {
                            Image("CloseIcon")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("Email")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.leading, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top)
                        
                        TextField("", text: $viewModel.email)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .font(.system(size: 24, weight: .semibold))
                            .tint(.white.opacity(0.5))
                            .foregroundStyle(.white)
                            .padding()
                            .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .foregroundStyle(.white.opacity(0.1))
                            )
                            .padding(.bottom)
                        
                        Text("Password")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.leading, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextField("", text: $viewModel.password)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .font(.system(size: 24, weight: .semibold))
                            .tint(.white.opacity(0.5))
                            .foregroundStyle(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundStyle(.white.opacity(0.1))
                            )
                        
                        Text("PasswordRequirements")
                            .font(.system(size: 14, weight: .regular))
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(viewModel.passwordIsNotCorrect ? .red : .white)
                            .padding(.leading, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        if viewModel.emailIsNotCorrect {
                            Text("IncorrectEmail")
                                .font(.system(size: 14, weight: .regular))
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.red)
                                .padding(.leading, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        if viewModel.emailIsAlreadyUsed {
                            Text("EmailAlreadyUsed")
                                .font(.system(size: 14, weight: .regular))
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.red)
                        }
                        
                        if viewModel.undefinedError {
                            Text("UndefinedError")
                                .font(.system(size: 14, weight: .regular))
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.red)
                        }
                        
                        Button {
                            viewModel.register()
                        } label: {
                            HStack {
                                if viewModel.requestSended && !viewModel.requestCompleted {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .tint(.white.opacity(0.5))
                                        .frame(width: 46, height: 46)
                                } else {
                                    Image("SignInIcon")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(.white)
                                        .padding(.trailing, 3)
                                        .background(
                                            Circle()
                                                .frame(width: 36, height: 36)
                                        )
                                        .frame(width: 46, height: 46)
                                }
                                
                                Text("SignIn")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .padding(.trailing)
                            }
                            .padding(4)
                            .background(
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(.white.opacity(0.1))
                            )
                            .padding(.top)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.white.opacity(0.1))
//                            .background(
//                                RoundedRectangle(cornerRadius: 30)
//                                    .stroke(.white.opacity(0.5), lineWidth: 2)
//                            )
                    )
                    Spacer()
                }
                .padding()
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    SignUpView(viewModel: SignUpViewModel())
}

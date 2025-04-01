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
        ZStack {
            LinearGradient(colors: [
                Color.gray,
                Color.brown,
                Color.gray,
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack {
                VStack {
                    Text("SigningIn")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    VStack {
                        Text("Email")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.leading, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextField("", text: $viewModel.email)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .font(.system(size: 24, weight: .semibold))
                            .tint(.white.opacity(0.5))
                            .foregroundStyle(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(viewModel.isDataCorrect ? .white.opacity(0.5) : .red, lineWidth: 2)
                                    .foregroundStyle(.white)
                            )
                            .padding(.bottom)
                        
                        VStack {
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
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(viewModel.isDataCorrect ? .white.opacity(0.5) : .red, lineWidth: 2)
                                        .foregroundStyle(.white)
                                )
                            
                            Text("PasswordRequirements")
                                .font(.system(size: 14, weight: .regular))
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(viewModel.isDataCorrect ? .white : .red)
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
                            HStack {
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
                                
                                Text("SignIn")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .padding(.trailing)
                            }
                            .padding(4)
                            .background(
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(.gray.opacity(0.3))
                                    .overlay(content: {
                                        RoundedRectangle(cornerRadius: 100)
                                            .stroke(.white.opacity(0.5), lineWidth: 2)
                                    })
                            )
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.gray.opacity(0.3))
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(.white.opacity(0.5), lineWidth: 2)
                            )
                    )
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    SignInView(viewModel: SignInViewModel())
}

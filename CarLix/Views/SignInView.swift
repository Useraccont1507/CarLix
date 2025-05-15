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
                Color.grayGradient,
                Color.brownGradient,
                Color.graphiteGradient,
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack {
                VStack {
                    Text("Вхід")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    VStack {
                        Text("Email")
                            .font(.callout)
                            .fontWeight(.semibold)
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
                        
                        VStack {
                            Text("Пароль")
                                .font(.callout)
                                .fontWeight(.semibold)
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
                            
                            Text("Пароль повинен містити хоча б 6 символів")
                                .font(.footnote)
                                .fontWeight(.regular)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(viewModel.isDataCorrect ? .white : .red)
                                .padding(.leading, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if !viewModel.isDataCorrect {
                                Text("Невірний email або пароль")
                                    .font(.footnote)
                                    .fontWeight(.regular)
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(.red)
                                    .padding(.leading, 8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.bottom)
                        
                        Button {
                            viewModel.signIn()
                        } label: {
                            HStack {
                                if viewModel.requestSended && !viewModel.resuestSuccessful {
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
                                
                                Text("Увійти")
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .padding(.trailing)
                            }
                            .padding(4)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundStyle(.white.opacity(0.1))
                            )
                        }
                        .disabled(viewModel.requestSended && !viewModel.resuestSuccessful)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundStyle(.black.opacity(0.1))
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

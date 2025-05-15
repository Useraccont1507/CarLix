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
                Color.grayGradient,
                Color.brownGradient,
                Color.graphiteGradient,
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack {
                VStack {
                    HStack {
                        Text("Реєстрація")
                            .font(.largeTitle)
                            .fontWeight(.bold)
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
                            .font(.headline)
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
                        
                        Text("Пароль")
                            .font(.headline)
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
                            .foregroundStyle(viewModel.passwordIsNotCorrect ? .red : .white)
                            .padding(.leading, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        if viewModel.emailIsNotCorrect {
                            Text("Неправильний email")
                                .font(.footnote)
                                .fontWeight(.regular)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.red)
                                .padding(.leading, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        if viewModel.emailIsAlreadyUsed {
                            Text("Схоже email вже використовується. Спробуйте інший")
                                .font(.footnote)
                                .fontWeight(.regular)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.red)
                        }
                        
                        if viewModel.undefinedError {
                            Text("Щось пішло не так. Спробуйте пізніше")
                                .font(.footnote)
                                .fontWeight(.regular)
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
                                    Image("SignUpIcon")
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
                                
                                Text("Зареєструватись")
                                    .font(.body)
                                    .fontWeight(.semibold)
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
                            .fill(.black.opacity(0.1))
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

//
//  AuthView.swift
//  CarLix
//
//  Created by Illia Verezei on 18.03.2025.
//

import SwiftUI

struct AuthView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [
                Color.grayGradient,
                Color.brownGradient,
                Color.graphiteGradient,
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack {
                Text("Авторизуйтесь перш ніж розпочати")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                Spacer()
                
                Button {
                    viewModel.moveToSignUp()
                } label: {
                    HStack {
                        Image("SignUpIcon")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.white)
                            .padding(.leading, 3)
                            .background(
                                Circle()
                                    .frame(width: 36, height: 36)
                            )
                            .frame(width: 46, height: 46)
                        
                        Text("Зареєструватись")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.trailing)
                    }
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 100)
                            .foregroundStyle(.white.opacity(0.1))
                    )
                }
                
                Text("або")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                
                Button {
                    viewModel.moveToSignIn()
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
                        
                        Text("Увійти")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.trailing)
                    }
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 100)
                            .foregroundStyle(.white.opacity(0.1))
                    )
                }
            }
            .padding()
        }
    }
}

#Preview {
    AuthView(viewModel: AuthViewModel())
}



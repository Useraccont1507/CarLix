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
                Color.gray,
                Color.brown,
                Color.gray,
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            VStack {
                Text("Authorize")
                    .font(.system(size: 32, weight: .semibold))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
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
                        
                        Text("SignUp")
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
                
                Text("Or")
                    .font(.system(size: 16, weight: .regular))
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
        }
    }
}

#Preview {
    AuthView(viewModel: AuthViewModel())
}



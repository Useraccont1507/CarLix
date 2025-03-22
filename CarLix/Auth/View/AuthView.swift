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
            LinearGradient(colors: [.mint, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack {
                Text("Authorize")
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
                Spacer()
                
                Button {
                    viewModel.moveToSignUp()
                } label: {
                    Text("SignUp")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(.mint)
                        )
                }
                
                Text("Or")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.darkGreyText)
                
                Button {
                    viewModel.moveToSignIn()
                } label: {
                    Text("SignIn")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(.mint)
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



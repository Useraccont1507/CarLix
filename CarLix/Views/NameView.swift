//
//  NameView.swift
//  CarLix
//
//  Created by Illia Verezei on 20.03.2025.
//

import SwiftUI

struct NameView: View {
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
                Text("LastStep")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                VStack {
                    VStack(alignment: .leading) {
                        Text("EnterFirstAndLastNames")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.leading, 8)
                        TextField("", text: $viewModel.userFirstAndLastName)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundStyle(.white.opacity(0.1))
                            )
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.bottom)
                    
                    Button {
                        viewModel.completeRegistration()
                    } label: {
                        Text("CompleteRegistration")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding()
                            .padding(.horizontal)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundStyle(.white.opacity(0.1))
                    )
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding()
                .padding(.vertical)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(.black.opacity(0.1))
                )
                
                Spacer()
            }
            .padding()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    NameView(viewModel: SignUpViewModel())
}

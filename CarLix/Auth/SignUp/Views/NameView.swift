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
        VStack {
            Text("LastStep")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.darkGreyText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("EnterFirstAndLastNames")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.darkGreyText)
                    .padding(.leading, 8)
                TextField("", text: $viewModel.userFirstAndLastName)
                    .font(.system(size: 24, weight: .semibold))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(viewModel.isNameEmpty ? .red : .mint, lineWidth: 2)
                            .foregroundStyle(.white)
                            .shadow(color:viewModel.isNameEmpty ? .red : .mint, radius: 20, x: 0, y: 2)
                        
                    )
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.bottom)
            
            Button {
                viewModel.completeRegistration()
            } label: {
                Text("CompleteRegistration")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .padding()
                    .padding(.horizontal)
            }
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .foregroundStyle(.mint)
            )
            .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            
        }
        .padding()
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    NameView(viewModel: SignUpViewModel())
}

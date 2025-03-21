//
//  VeifySMSView.swift
//  CarLix
//
//  Created by Illia Verezei on 18.03.2025.
//

import SwiftUI

struct VerifySMSView: View {
    @ObservedObject var viewModel: SignUpViewModel
    
    var body: some View {
        VStack {
            Text("SMSCode")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.darkGreyText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            VStack {
                
                Text("EnterSMSCode")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.darkGreyText)
                    .frame(maxWidth: .infinity, alignment:  .leading)
                    .padding(.leading, 8)
                
                CodeField(viewModel: viewModel)
                
                HStack {
                    Text("SMSWasSendedOn")
                        .font(.system(size: 14, weight: .regular))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(viewModel.isSmsCodeCorrect ? .gray : .red)
                    Text("\(viewModel.phoneNumber)")
                        .font(.system(size: 14, weight: .regular))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(viewModel.isSmsCodeCorrect ? .gray : .red)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)
                
                if !viewModel.isSmsCodeCorrect {
                    Text("IncorrectSMS")
                        .font(.system(size: 14, weight: .regular))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                }
            }
            .padding(.bottom)
            
            
            Button {
                viewModel.checkSMS()
            } label: {
                Text("ConfirmCode")
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
    VerifySMSView(viewModel: SignUpViewModel())
}

struct CodeField: View {
    @FocusState var focusedIndex: Int?
    @ObservedObject var viewModel: SignUpViewModel
    
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<6) { i in
                TextField("", text: $viewModel.SMSCode[i])
                    .multilineTextAlignment(.center)
                    .focused($focusedIndex, equals: i)
                    .keyboardType(.numberPad)
                    .font(.system(size: 24, weight: .semibold))
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(viewModel.isSmsCodeCorrect ? .mint : .red, lineWidth: 2)
                            .foregroundStyle(.white)
                            .shadow(color: viewModel.isSmsCodeCorrect ? .mint : .red, radius: 40, x: 0, y: 2)
                    }
                    .onChange(of: viewModel.SMSCode[i]) { newValue in
                        if newValue.count > 1 {
                            viewModel.SMSCode[i] = String(newValue.prefix(1))
                        }
                        if !newValue.isEmpty {
                            moveToNextField(from: i)
                        }
                    }
            }
        }
    }
    
    private func moveToNextField(from index: Int) {
        if index < 5 {
            focusedIndex! += 1
        } else {
            focusedIndex = nil
        }
    }
}

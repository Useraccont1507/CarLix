//
//  ProfileView.swift
//  CarLix
//
//  Created by Illia Verezei on 06.05.2025.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [
                Color.grayGradient,
                Color.brownGradient,
                Color.graphiteGradient,
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack {
                ProfileHeaderBar(viewModel: viewModel)
                    .blur(radius: viewModel.blur)
                
                ProfileCard(viewModel: viewModel)
                    .animation(.linear, value: viewModel.isEditCardState)
                    .blur(radius: viewModel.blur)
                
                ActionsSectionView(viewModel: viewModel)
                    .animation(.linear, value: viewModel.isEditCardState)
                    .blur(radius: viewModel.blur)
                
                Spacer()
            }
        }
        .onAppear {
            viewModel.loadUserNameAndDate()
        }
        .alert("Видалення профілю", isPresented: $viewModel.isDeleteProfileAlert, actions: {
            HStack {
                Button("Видалити") {
                    viewModel.deleteProfile()
                }
                
                Button("Скасувати", role: .cancel) {
                    viewModel.isAlert = false
                }
            }
        }, message: {
            Text("Усі записи будуть втрачені")
        })
        .alert("Введіть пароль перш ніж видалити акаунт", isPresented: $viewModel.isPasswordAlert, actions: {
            HStack {
                Button("Підтвердити") {
                    //viewModel.deleteProfile()
                }
                
                Button("Скасувати", role: .cancel) {
                    viewModel.isPasswordAlert = false
                }
            }
        }, message: {
            Text("Усі записи будуть втрачені")
        })
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel(homeCoordinator: nil, storageService: nil, authService: nil))
}

struct ProfileHeaderBar: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    viewModel.back()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        Text("Головна")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
                
                Spacer()
            }
            .padding()
            
            HStack {
                Text("Профіль")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.leading)
                
                Spacer()
            }
        }
    }
}

struct ProfileCard: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        HStack(alignment: viewModel.isEditCardState ? .top : .center) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 34, height: 34)
                .font(.system(size: 32, weight: .semibold))
                .foregroundStyle(.white.opacity(0.5))
                .padding(.leading, 8)
                .padding(.trailing, 16)
            
            if !viewModel.isEditCardState {
                VStack(alignment: .leading) {
                    Text(viewModel.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Дата створення \(viewModel.dateCreatedString)")
                        .font(.callout)
                }
                .foregroundStyle(.white)
            } else {
                VStack {
                    FieldView(isOptional: false, title: "Ім'я та призвіще", placeholder: "Олександр Мельник", value: $viewModel.newName)
                    
                    Button {
                        if viewModel.name.isEmpty {
                            viewModel.isAlert = true
                        } else {
                            viewModel.editName()
                        }
                    } label: {
                        HStack {
                            Image(systemName: "pencil.circle")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.white)
                            
                            Text("Готово")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(.white.opacity(0.1))
                        )
                    }
                    .transition(.scale)
                }
                .animation(.linear, value: viewModel.isEditCardState)
            }
            
            Spacer()
            
            Button {
                viewModel.isEditCardState.toggle()
            } label: {
                Image(systemName: !viewModel.isEditCardState ? "pencil.circle" : "xmark.circle")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.black.opacity(0.1))
        )
        .padding()
    }
}

struct ActionsSectionView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Button("Видалити профіль") {
                viewModel.isDeleteProfileAlert = true
            }
            .foregroundStyle(.white)
            
            Rectangle()
                .fill(.secondary)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
            
            Button("Вийти") {
                viewModel.exit()
            }
            .foregroundStyle(.white)
        }
        .fontWeight(.semibold)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.black.opacity(0.1))
        )
        .padding()
    }
}

//
//  AddFuelServiceView.swift
//  CarLix
//
//  Created by Illia Verezei on 28.04.2025.
//

import SwiftUI

struct AddFuelServiceView: View {
    @ObservedObject var viewModel: AddFuelServiceViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [
                Color.grayGradient,
                Color.brownGradient,
                Color.graphiteGradient,
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            ZStack(alignment: .top) {
                VStack {
                    Spacer().frame(height: 140)
                    
                    if viewModel.isFuelAdded {
                        CustomAddFuelForm(viewModel: viewModel)
                            .blur(radius: viewModel.blur)
                    } else {
                        CustomAddServiceView(viewModel: viewModel)
                            .blur(radius: viewModel.blur)
                    }
                }
                
                AddFuelHeaderBar(viewModel: viewModel)
                    .blur(radius: viewModel.blur)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $viewModel.isImagePickerPresented, content: {
            ImagePickerView(image: $viewModel.documents)
        })
        .onAppear {
            viewModel.loadCars()
        }
        .animation(.easeInOut, value: viewModel.blur)
    }
}

#Preview {
    AddFuelServiceView(viewModel: AddFuelServiceViewModel(blur: 0, coordinator: nil, storage: nil, isFuelAdded: false))
}

struct AddFuelHeaderBar: View {
    @ObservedObject var viewModel: AddFuelServiceViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    viewModel.close()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        Text("Мої авто")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
                
                Spacer()
                
                Button {
                    viewModel.add()
                } label: {
                    HStack {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        Text("Додати")
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
            }
            .padding()
            
            HStack {
                Text(viewModel.isFuelAdded ? "Додати пальне" : "Додати сервіс")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.leading)
                
                Spacer()
            }
        }
    }
}

struct CustomAddFuelForm: View {
    @ObservedObject var viewModel: AddFuelServiceViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16) {
                HStack {
                    Text("Авто")
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.leading, 8)
                    
                    Spacer()
                    
                    Picker("Авто", selection: $viewModel.carID) {
                        ForEach(viewModel.cars) { car in
                            Text(car.name).tag(car.id)
                        }
                    }
                    .tint(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.white.opacity(0.1))
                    )
                }
                
                FieldView(isOptional: false, title: "Кількість літрів", placeholder: "Наприклад, 20", value: $viewModel.liters)
                
                FieldView(isOptional: true, title: "Ціна за літр", placeholder: "Наприклад, 55.44", value: $viewModel.pricePerLiter)
                
                FuelPickerView(fuelType: $viewModel.fuelType)
                
                FieldView(isOptional: false, title: "Поточний пробіг", placeholder: "Наприклад, 125000", value: $viewModel.currentMileage)
                
                FieldView(isOptional: true, title: "Назва АЗС", placeholder: "Наприклад, Wog", value: $viewModel.stationName)
                
                FieldView(isOptional: true, title: "Адреса АЗС", placeholder: "Наприклад, Кільцева 7а", value: $viewModel.stationAdress)
                
                AddDocView(isOptional: true, title: "Чек", viewModel: viewModel)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(.black.opacity(0.1))
            )
            .padding()
        }
    }
}

struct CustomAddServiceView: View {
    @ObservedObject var viewModel: AddFuelServiceViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16) {
                HStack {
                    Text("Авто")
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.leading, 8)
                    
                    Spacer()
                    
                    Picker("Авто", selection: $viewModel.carID) {
                        ForEach(viewModel.cars) { car in
                            Text(car.name).tag(car.id)
                        }
                    }
                    .tint(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.white.opacity(0.1))
                    )
                }
                
                FieldView(isOptional: false, title: "Короткий опис", placeholder: "Наприклад, планове ТО", value: $viewModel.workDescription)
                
                TextView(isOptional: true, title: "Детальний опис", text: $viewModel.detailedWorkDescription)
                
                FieldView(isOptional: true, title: "Вартість", placeholder: "Наприклад, 12000", value: $viewModel.price)
                
                FieldView(isOptional: false, title: "Поточний пробіг", placeholder: "Наприклад, 125000", value: $viewModel.currentMileage)
                
                FieldView(isOptional: true, title: "Назва СТО", placeholder: "Наприклад, сто", value: $viewModel.stationName)
                
                FieldView(isOptional: true, title: "Адреса СТО", placeholder: "Наприклад, Кільцева 7а", value: $viewModel.stationAdress)
                
                AddNotificationServiceDateView(viewModel: viewModel)
                
                AddDocView(isOptional: true, title: "Чек", viewModel: viewModel)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(.black.opacity(0.1))
            )
            .padding()
        }
    }
}

struct TextView: View {
    @FocusState var keyboardOn: Bool
    var isOptional: Bool
    var title: String
    @Binding var text: String
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.leading, 8)
                    .frame(width: 200, alignment: .leading)
                
                Spacer()
                
                if isOptional == true {
                    Text("Не обов'язково")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.white.opacity(0.5))
                        .padding(.trailing, 8)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            
            TextEditor(text: $text)
                .focused($keyboardOn)
                .bold()
                .foregroundStyle(.white)
                .scrollContentBackground(.hidden)
                .frame(height: 120)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(.white.opacity(0.1))
                )
            
            Button("Hide keyboard") {
                keyboardOn = false
            }
            .font(.caption)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct AddNotificationServiceDateView: View {
    @ObservedObject var viewModel: AddFuelServiceViewModel
    
    var body: some View {
        Toggle("Сповістити про наступний сервіс", isOn: $viewModel.isNotified)
            .foregroundStyle(.white)
            .bold()
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(.white.opacity(0.1))
            )
        
        if viewModel.isNotified {
            DatePicker("Дата", selection: $viewModel.notificationDate)
                .foregroundStyle(.white)
                .transition(.opacity)
                .padding()
        }
    }
}

struct AddDocView: View {
    var isOptional: Bool
    var title: String
    @ObservedObject var viewModel: AddFuelServiceViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.leading, 8)
                    .frame(width: 200, alignment: .leading)
                
                Spacer()
                
                if isOptional == true {
                    Text("Не обов'язково")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.white.opacity(0.5))
                        .padding(.trailing, 8)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            if let image = viewModel.documents {
                VStack {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                    
                    HStack {
                        Button {
                            viewModel.isImagePickerPresented.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "arrow.counterclockwise")
                                    .foregroundStyle(.white)
                                
                                Text("Вибрати ще раз")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundStyle(.white)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(.white.opacity(0.1))
                            )
                        }
                        
                        Button {
                            viewModel.documents = nil
                        } label: {
                            HStack {
                                Image(systemName: "trash")
                                    .foregroundStyle(.white)
                                
                                Text("Видалити")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundStyle(.white)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(.white.opacity(0.1))
                            )
                        }
                    }
                }
                
            } else {
                ZStack {
                    Button {
                        viewModel.isImagePickerPresented.toggle()
                    } label: {
                        VStack(spacing: 16) {
                            Image(systemName: "plus")
                                .resizable()
                                .foregroundStyle(.white)
                                .frame(width: 50, height: 50)
                            
                            Text("Торкніться, щоб додати")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.white.opacity(0.1))
                    )
                }
            }
        }
    }
}

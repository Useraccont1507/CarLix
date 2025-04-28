//
//  AddCarView.swift
//  CarLix
//
//  Created by Illia Verezei on 04.04.2025.
//

import SwiftUI

struct AddEditCarView: View {
    @ObservedObject var viewModel: AddEditCarViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [
                Color.grayGradient,
                Color.brownGradient,
                Color.graphiteGradient,
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack {
                AddCarHeaderView(viewModel: viewModel)
                
                FieldsView(viewModel: viewModel)
            }
            .blur(radius: viewModel.blur)
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $viewModel.isImagePickerPresented, content: {
            ImagePickerView(image: $viewModel.photo)
        })
        .overlay {
            if viewModel.savingCycle != .notTapped {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
            }
            
            switch viewModel.savingCycle {
            case .notTapped: EmptyView()
            case .saveTapped: LoadingView()
            case .saved: SuccessSaving(viewModel: viewModel)
            case .notSaved: SavingErrorView(viewModel: viewModel)
            case .netwotkError: NetworkErrorView(viewModel: viewModel)
            }
        }
        .transition(.opacity)
        .animation(.smooth(duration: 0.5, extraBounce: 0.2), value: viewModel.savingCycle)
    }
}

#Preview {
    AddEditCarView(viewModel: AddEditCarViewModel(action: .edit, carToEdit: nil))
}

struct AddCarHeaderView: View {
    @ObservedObject var viewModel: AddEditCarViewModel
    
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
                    viewModel.checkValuesAndSave()
                } label: {
                    HStack {
                        Image(systemName: viewModel.action == .add ? "plus" : "pencil.circle")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        Text(viewModel.action == .add ? "Додати" : "Готово")
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
                Text( viewModel.action == .add ? "Додати авто" : "Редагувати авто")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.leading)
                
                Spacer()
            }
        }
    }
}

struct FieldsView: View {
    @ObservedObject var viewModel: AddEditCarViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                FieldView(isOptional: false, title: "Назва", placeholder: "Наприклад, Audi A4 B8", value: $viewModel.carName)
                
                CarTypeGrid(carType: $viewModel.carType)
                
                FieldView(isOptional: false, title: "Рік випуску", placeholder: "Наприклад, 2013", value: $viewModel.year)
                
                FuelPickerView(fuelType: $viewModel.fuel)
                
                FieldView(isOptional: false, title: "Об'єм двигуна", placeholder: "Наприклад, 2.0", value: $viewModel.engineSize)
                
                FieldView(isOptional: true, title: "Маркування двигуна", placeholder: "Наприклад, TFSI", value: $viewModel.engineCode)
                
                TransmissionPickerView(transmission: $viewModel.typeOfTransmission)
                
                FieldView(isOptional: false, title: "Пробіг", placeholder: "Наприклад, 107000", value: $viewModel.carMileage)
                
                TypeOfDrivePickerView(drive: $viewModel.typeOfDrive)
                
                FieldView(isOptional: true, title: "VIN", placeholder: "", value: $viewModel.vinCode)
                
                AddPhotoView(isOptional: true, title: "Фото авто", viewModel: viewModel)
                
            }
            .padding(.top)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(.black.opacity(0.1))
            )
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
    }
}

struct FieldView: View {
    var isOptional: Bool
    var title: String
    var placeholder: String
    @Binding var value: String
    
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
            
            TextField(placeholder, text: $value)
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
                .padding(.bottom)
        }
    }
}

struct CarTypeGrid: View {
    @Binding var carType: CarType?
    let columns: [GridItem] = [GridItem(), GridItem()]
    
    var body: some View {
        VStack {
            Text("Тип авто")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.leading, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: columns) {
                ForEach(CarType.allCases, id: \.self) { type in
                    button(for: type)
                }
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .foregroundStyle(.white.opacity(0.1))
            )
            .padding(.bottom)
        }
        .animation(.linear, value: carType)
    }
    
    private func button(for type: CarType) -> some View {
            Button {
                carType = type
            } label: {
                Text(type.rawValue)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(carType == type ? .white : .white.opacity(0.5))
                    .padding()
                    .background(
                        Group {
                            if carType == type {
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundStyle(.white.opacity(0.1))
                            }
                        }
                            .transition(.identity)
                    )
            }
        }
}

struct FuelPickerView: View {
    @Binding var fuelType: FuelType?
    
    var body: some View {
        VStack {
            Text("Тип палива")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.leading, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                ForEach(FuelType.allCases, id: \.self) { button(for: $0)}
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .foregroundStyle(.white.opacity(0.1))
            )
            .padding(.bottom)
        }
        .animation(.linear, value: fuelType)
    }
    
    private func button(for type: FuelType) -> some View {
            Button {
                fuelType = type
            } label: {
                Text(type.rawValue)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(fuelType == type ? .white : .white.opacity(0.5))
                    .padding()
                    .background(
                        Group {
                            if fuelType == type {
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundStyle(.white.opacity(0.1))
                            }
                        }
                            .transition(.identity)
                    )
            }
        }
}

struct TransmissionPickerView: View {
    @Binding var transmission: TypeOfTransmission?
    
    var body: some View {
        VStack {
            Text("Тип трансмісії")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.leading, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                ForEach(TypeOfTransmission.allCases, id: \.self) { button(for: $0) }
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .foregroundStyle(.white.opacity(0.1))
            )
            .padding(.bottom)
        }
        .animation(.linear, value: transmission)
    }
    
    private func button(for type: TypeOfTransmission) -> some View {
            Button {
                transmission = type
            } label: {
                Text(type.rawValue)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(transmission == type ? .white : .white.opacity(0.5))
                    .padding()
                    .background(
                        Group {
                            if transmission == type {
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundStyle(.white.opacity(0.1))
                            }
                        }
                            .transition(.identity)
                    )
            }
        }
}

struct TypeOfDrivePickerView: View {
    @Binding var drive: TypeOfDrive?
    
    var body: some View {
        VStack {
            Text("Тип приводу")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.leading, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                ForEach(TypeOfDrive.allCases, id: \.self) { button(for: $0) }
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .foregroundStyle(.white.opacity(0.1))
            )
            .padding(.bottom)
        }
        .animation(.linear, value: drive)
    }
    
    private func button(for type: TypeOfDrive) -> some View {
            Button {
                drive = type
            } label: {
                Text(type.rawValue)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(drive == type ? .white : .white.opacity(0.5))
                    .padding()
                    .background(
                        Group {
                            if drive == type {
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundStyle(.white.opacity(0.1))
                            }
                        }
                            .transition(.identity)
                    )
            }
        }
}

struct AddPhotoView: View {
    var isOptional: Bool
    var title: String
    @ObservedObject var viewModel: AddEditCarViewModel
    
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
            if let image = viewModel.photo {
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
                            viewModel.photo = nil
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

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .tint(.white)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white.opacity(0.1))
                    .frame(width: 100, height: 100)
            )
    }
}

struct SuccessSaving: View {
    @ObservedObject var viewModel: AddEditCarViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "checkmark")
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(.white)
                .padding()
            
            Text("Авто було успішно збережене")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .padding()
            
            Button {
                viewModel.close()
            } label: {
                Text("ок")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.white.opacity(0.1))
                    )
            }
        }
        .padding([.top, .horizontal], 32)
        .padding(.bottom)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.1))
        )
        .padding()
    }
}

struct SavingErrorView: View {
    @ObservedObject var viewModel: AddEditCarViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "xmark")
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(.white)
                .padding()
            
            Text("Упс\nЩось пішло не так\nвпевніться, що заповнили усі поля правильно ")
                .multilineTextAlignment(.center)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .padding()
            
            Button {
                viewModel.savingCycle = .notTapped
                viewModel.blur = 0
            } label: {
                Text("ок")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.white.opacity(0.1))
                    )
            }
        }
        .padding([.top, .horizontal], 32)
        .padding(.bottom)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.1))
        )
    }
}

struct NetworkErrorView: View {
    @ObservedObject var viewModel: AddEditCarViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "xmark")
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(.white)
                .padding()
            
            Text("Упс\nЩось пішло не так\nСпробуйте пізніше")
                .multilineTextAlignment(.center)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .padding()
            
            Button {
                viewModel.savingCycle = .notTapped
                viewModel.blur = 0
            } label: {
                Text("ок")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.white.opacity(0.1))
                    )
            }
        }
        .padding([.top, .horizontal], 32)
        .padding(.bottom)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.1))
        )
    }
}

//
//  FullCarDescriptionView.swift
//  CarLix
//
//  Created by Illia Verezei on 26.04.2025.
//

import SwiftUI

struct FullCarDescriptionView: View {
    @ObservedObject var viewModel: FullCarDescriptionViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [
                Color.grayGradient,
                Color.brownGradient,
                Color.graphiteGradient,
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack {
                CarDescriptionHeaderView(viewModel: viewModel)
                
                
                DescriptionScrollView(viewModel: viewModel)
            }
            .blur(radius: viewModel.blur)
            .overlay {
                switch viewModel.deleteStatusState {
                case .notTapped:
                    EmptyView()
                case .notStarted:
                    DeleteAlertView(viewModel: viewModel)
                        .transition(.scale)
                case .started:
                    LoadingView()
                        .transition(.scale)
                case .successful:
                    DeleteCarsSuccessView(viewModel: viewModel)
                        .transition(.scale)
                case .error:
                    DeleteCarsErrorView(viewModel: viewModel)
                        .transition(.scale)
                }
            }
        }
        .animation(.smooth(duration: 0.5, extraBounce: 0.2), value: viewModel.deleteStatusState)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.loadFuelsAndServices()
        }
    }
}

#Preview {
    FullCarDescriptionView(viewModel: FullCarDescriptionViewModel(coordinator: nil, storage: nil, car: nil))
}

struct CarDescriptionHeaderView: View {
    @ObservedObject var viewModel: FullCarDescriptionViewModel
    
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
                        
                        Text("Мої авто")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
                
                Spacer()
            }
            .padding()
            
            if let car = viewModel.car {
                HStack {
                    Text(car.name)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.leading)
                    
                    Spacer()
                }
            }
        }
    }
}

struct DescriptionScrollView: View {
    @ObservedObject var viewModel: FullCarDescriptionViewModel
    
    var body: some View {
        List {
            if let car = viewModel.car {
                if (!car.fuels.isEmpty && !car.services.isEmpty) || (!car.fuels.isEmpty || !car.services.isEmpty) {
                    TotalCostsView(viewModel: viewModel)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
                
                if let car = viewModel.car {
                    
                    FullDescription(car: car)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    
                }
                
                FuelsView(viewModel: viewModel, car: car)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                
                ServicesView(viewModel: viewModel, car: car)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
            
            HStack(spacing: 16) {
                Spacer(minLength: 0)
                
                Button {
                    viewModel.blur = 10
                    viewModel.deleteStatusState = .notStarted
                } label: {
                    HStack {
                        Image(systemName: "trash")
                            .foregroundStyle(.white)
                        Text("Видалити авто")
                            .font(.callout)
                            .bold()
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(.red)
                )
                .buttonStyle(.borderless)
                
                Button {
                    viewModel.moveToEdit()
                } label: {
                    HStack {
                        Image(systemName: "pencil")
                            .foregroundStyle(.white)
                        Text("Редагувати")
                            .font(.callout)
                            .bold()
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(.orange)
                )
                .buttonStyle(.borderless)
                
                Spacer(minLength: 0)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
    }
}

struct TotalCostsView: View {
    @ObservedObject var viewModel: FullCarDescriptionViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Витрачено коштів:")
                    .bold()
                
                Spacer()
            }
            
            HStack(spacing: 64) {
                VStack {
                    Text(String(viewModel.getSumCostOfFuel()))
                        .font(.title)
                        .bold()
                    
                    Text("Пальне")
                        .bold()
                }
                
                VStack {
                    Text(String(viewModel.getSumCostOfService()))
                        .font(.title)
                        .bold()
                    
                    Text("Сервіс")
                        .bold()
                }
            }
            .padding(32)
            
            HStack {
                Text("У період з: \(viewModel.getPeriod().0) - \(viewModel.getPeriod().1)")
                    .font(.caption)
                    .bold()
                
                Spacer()
            }
        }
        .foregroundStyle(.white)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.black.opacity(0.1))
        )
    }
}

struct FuelsView: View {
    @ObservedObject var viewModel: FullCarDescriptionViewModel
    let car: Car
    
    var body: some View {
        VStack {
            HStack {
                Text("Пальне")
                    .bold()
                    .foregroundStyle(.white)
                    .padding([.leading, .top])
                
                Spacer()
                
                Button {
                    viewModel.deleteFuelHistory()
                } label: {
                    Text("Видалити усе")
                        .font(.footnote)
                        .bold()
                        .foregroundStyle(.white)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white.opacity(0.1))
                )
                .padding([.trailing, .top])
            }
            
            if !car.fuels.isEmpty {
                ForEach(car.fuels, id: \.id) { fuel in
                    Rectangle()
                        .fill(.white.opacity(0.1))
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                    FuelRow(fuel: fuel)
                }
            } else {
                Rectangle()
                    .fill(.white.opacity(0.1))
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                
                Text("Не було додано жодної заправки")
                    .foregroundStyle(.white)
                    .padding()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.black.opacity(0.1))
        )
    }
}

struct FuelRow: View {
    var fuel: CarFuel
    
    var body: some View {
        VStack {
            HStack {
                Text(String(fuel.liters) + "л")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text(fuel.fuelType.rawValue.localizedCapitalized)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
            .padding(.bottom, 36)
            .padding(.top, 16)
            
            HStack {
                Text(getDateString(date: fuel.date))
                    .foregroundStyle(.white)
                
                Spacer()
                
                if let pricePerLiter = fuel.pricePerLiter {
                    Text(String(pricePerLiter) + " за л")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
            }
            
            HStack {
                if !fuel.stationName.isEmpty,
                   !fuel.stationAddress.isEmpty {
                    Text(String(fuel.stationName) + " " + String(fuel.stationAddress))
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                if let price = fuel.price {
                    Text("Разом " + String(Int(price.rounded())))
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
            }
            .padding(.bottom)
            
            if let image = fuel.documents {
                Image(uiImage: image)
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.bottom)
            }
        }
        .padding(.horizontal)
    }
    
    func getDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = .current
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.string(from: date)
    }
}

struct ServicesView: View {
    @ObservedObject var viewModel: FullCarDescriptionViewModel
    let car: Car
    
    var body: some View {
        VStack {
            HStack {
                Text("Сервіс")
                    .bold()
                    .foregroundStyle(.white)
                    .padding([.leading, .top])
                
                Spacer()
                
                Button {
                    viewModel.deleteServiceHistory()
                } label: {
                    Text("Видалити усе")
                        .font(.footnote)
                        .bold()
                        .foregroundStyle(.white)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white.opacity(0.1))
                )
                .padding([.trailing, .top])
            }
            
            if !car.services.isEmpty {
                Rectangle()
                    .fill(.white.opacity(0.1))
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                
                ForEach(car.services, id: \.id) { service in
                    ServiceRow(service: service)
                }
            } else {
                Rectangle()
                    .fill(.white.opacity(0.1))
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                
                Text("Не було додано жодного запису")
                    .foregroundStyle(.white)
                    .padding()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.black.opacity(0.1))
        )
    }
}

struct ServiceRow: View {
    var service: CarService
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(.white.opacity(0.1))
                .frame(height: 1)
                .frame(maxWidth: .infinity)
            
            HStack {
                Text(service.workDescription)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .padding(.bottom, 8)
            
            if !service.detailedDescription.isEmpty {
                HStack {
                    Text(service.detailedDescription)
                        .multilineTextAlignment(.leading)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .padding(.bottom)
            }
            
            HStack {
                Text(getDateString(date: service.date))
                    .font(.body)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text(String(service.currentMileage) + "km")
                    .font(.body)
                    .foregroundStyle(.white)
            }
            .padding(.bottom)
            
            HStack {
                Text((service.stationName) + "\n" + (service.stationAddress))
                    .font(.body)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text("Разом: " + String(Int(service.price.rounded())))
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
            .padding(.bottom)
            
            HStack {
                
                if let notificationDate = service.notificationDate {
                    Text("Нагадати мені: " + getDateString(date: notificationDate))
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.bottom)
                }
                
                Spacer()
            }
            
            if let image = service.documents {
                Image(uiImage: image)
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.bottom)
            }
        }
        .padding(.horizontal)
    }
    
    func getDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = .current
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.string(from: date)
    }
}

struct FullDescription: View {
    var car: Car
    
    var body: some View {
        VStack {
            if let image = car.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .padding(.top, 4)
            } else {
                Image("DefaultCar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .padding(.top, 4)
            }
            
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .foregroundStyle(.gray)
            
            VStack(spacing: 16) {
                
                InfoRow(title: "Тип кузова", value: car.type.rawValue)
                
                
                InfoRow(title: "Двигун", value: car.engineName)
                
                InfoRow(title: "Пробіг", value: "\(car.carMileage)" + " km")
                
                InfoRow(title: "Паливо", value: car.fuel.rawValue)
                
                InfoRow(title: "Привід", value: car.typeOfDrive.rawValue)
                
                
                InfoRow(title: "Тип трансімісії", value: car.typeOfTransmission.rawValue)
                
                InfoRow(title: "Рік", value: "\(car.year)")
                
                if !car.vinCode.isEmpty {
                    InfoRow(title: "VIN", value: car.vinCode)
                    
                }
            }
            .padding()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.black.opacity(0.1))
        )
    }
}


struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(.white)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(.white)
        }
    }
}

struct DeleteAlertView: View {
    @ObservedObject var viewModel: FullCarDescriptionViewModel
    
    var body: some View {
        VStack {
            VStack {
                Text("Ви точно бажаєте видалити дані?")
                Text("Усі записи будуть втрачені")
            }
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.bottom)
            
            HStack(spacing: 16) {
                Button {
                    viewModel.blur = 0
                    viewModel.deleteStatusState = .notTapped
                } label: {
                    Text("Скасувати")
                        .font(.callout)
                        .bold()
                        .foregroundStyle(.white)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.white.opacity(0.1))
                )
                
                Button {
                    viewModel.deleteCar()
                } label: {
                    Text("Видалити")
                        .font(.callout)
                        .bold()
                        .foregroundStyle(.white)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.red)
                )
            }
        }
        .padding([.top, .leading, .trailing], 32)
        .padding(.bottom)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(.white.opacity(0.1))
        )
    }
}

struct DeleteCarsSuccessView: View {
    @ObservedObject var viewModel: FullCarDescriptionViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Дані були успішно видалені")
                .foregroundStyle(.white)
                .bold()
            
            Button {
                viewModel.blur = 0
                viewModel.deleteStatusState = .notTapped
            } label: {
                Text("ОК")
                    .bold()
                    .foregroundStyle(.white)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(.white.opacity(0.1))
            )
        }
        .padding([.top, .horizontal], 32)
        .padding(.bottom)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.white.opacity(0.1))
        )
    }
}


struct DeleteCarsErrorView: View {
    @ObservedObject var viewModel: FullCarDescriptionViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Упс. Щось пішло не так.\nСпробуйте пізніше")
                .multilineTextAlignment(.center)
                .bold()
                .foregroundStyle(.white)
            
            Button {
                viewModel.blur = 0
                viewModel.deleteStatusState = .notTapped
            } label: {
                Text("ОК")
                    .bold()
                    .foregroundStyle(.white)
                    .bold()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(.white.opacity(0.1))
            )
        }
        .padding([.top, .horizontal], 32)
        .padding(.bottom)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.white.opacity(0.1))
        )
    }
}

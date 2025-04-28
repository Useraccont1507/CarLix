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
            .overlay {
                ZStack {
                    if viewModel.isLoadingViewPresented {
                        ZStack {
                            Color.black.opacity(0.5)
                                .ignoresSafeArea()
                            
                            LoadingView()
                                .transition(.scale)
                        }
                    }
                }
            }
        }
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
        ScrollView(.vertical) {
            LazyVStack(spacing: 16) {
                if let car = viewModel.car {
                    if (!car.fuels.isEmpty && !car.services.isEmpty) || (!car.fuels.isEmpty || !car.services.isEmpty) {
                        TotalCostsView(viewModel: viewModel)
                    }
                    
                    FuelsView(viewModel: viewModel, car: car)
                    ServicesView(viewModel: viewModel, car: car)
                }
                
                Button {
                    viewModel.deleteFuelHistory()
                } label: {
                    HStack {
                        Image(systemName: "trash")
                            .foregroundStyle(.white)
                        Text("Видалити пальне")
                            .font(.callout)
                            .bold()
                            .foregroundStyle(.white)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(.red)
                )
                .frame(width: 220)
                
                Button {
                    viewModel.deleteServiceHistory()
                } label: {
                    HStack {
                        Image(systemName: "trash")
                            .foregroundStyle(.white)
                        Text("Видалити сервіси")
                            .font(.callout)
                            .bold()
                            .foregroundStyle(.white)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(.red)
                )
                .frame(width: 220)
            }
        }
        .scrollIndicators(.hidden)
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
        .padding(.horizontal)
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
            }
            
            if !car.fuels.isEmpty {
                ForEach(car.fuels, id: \.id) { fuel in
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
        .padding(.horizontal)
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
                    Text(String(fuel.stationName) + String(fuel.stationAddress))
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
            }
            
            if !car.services.isEmpty {
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
        .padding(.horizontal)
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

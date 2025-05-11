//
//  HomeView.swift
//  CarLix
//
//  Created by Illia Verezei on 05.05.2025.
//

import SwiftUI
import Charts

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [
                Color.grayGradient,
                Color.brownGradient,
                Color.graphiteGradient,
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack {
                HeaderHomeBar(viewModel: viewModel)
                    .blur(radius: viewModel.blur)
                
                ScrollView {
                    LazyVStack {
                        DatePickerView(viewModel: viewModel, selectedDateType: $viewModel.selectedDateType)
                        
                        TotalAllCarsCostsView(viewModel: viewModel)
                        
                        ExpencesChartView(viewModel: viewModel)
                        
                        ExpenseFuelServiceChartView(viewModel: viewModel)
                    }
                }
                .blur(radius: viewModel.blur)
            }
            .onAppear {
                viewModel.loadAllData()
            }
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(coordinator: nil, storageService: nil))
}

struct HeaderHomeBar: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        HStack {
            Text("Головна")
                .font(.system(size: 46, weight: .bold))
                .foregroundStyle(.white)
            
            Spacer()
            
            Button {
                viewModel.moveToProfile()
            } label: {
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.5))
                    .background(
                        Circle()
                            .fill(.black.opacity(0.1))
                            .frame(width: 50, height: 50)
                    )
            }
            .frame(width: 50, height: 50)
        }
        .padding()
    }
}

struct DatePickerView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var selectedDateType: DateType
    
    var body: some View {
        VStack {
            Text("Дата")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.leading, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                ForEach(DateType.allCases, id: \.self) { button(for: $0)}
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .foregroundStyle(.black.opacity(0.1))
            )
            .padding(.bottom)
        }
        .padding(.horizontal)
        .animation(.linear, value: selectedDateType)
    }
    
    private func button(for type: DateType) -> some View {
        Button {
            selectedDateType = type
            viewModel.fitlerData(with: type)
        } label: {
            Text(type.rawValue)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(selectedDateType == type ? .white : .white.opacity(0.5))
                .padding()
                .background(
                    Group {
                        if selectedDateType == type {
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundStyle(.white.opacity(0.1))
                        }
                    }
                        .transition(.identity)
                )
        }
    }
}

struct TotalAllCarsCostsView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Витрачено коштів")
                    .bold()
                
                Spacer()
            }
            
            Rectangle()
                .fill(.secondary)
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .padding(.bottom, 8)
            
            VStack(spacing: 16) {
                ForEach(viewModel.cars, id: \.id) { car in
                    HStack {
                        Text(car.name)
                        
                        Spacer()
                        
                        Text(String(Int(viewModel.calculateCarCost(car).rounded())))
                    }
                    .font(.title2)
                    .bold()
                }
                .padding(.vertical, 8)
            }
        }
        .foregroundStyle(.white)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.black.opacity(0.1))
        )
        .padding(.bottom)
        .padding(.horizontal)
    }
}

struct ExpencesChartView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        let chartData = viewModel.getAnalyticsDateAndCost()
        
        VStack {
            HStack {
                Text("Витрати")
                    .bold()
                Spacer()
            }
            
            Rectangle()
                .fill(.secondary)
                .frame(height: 1)
                .padding(.bottom, 8)
            
            Chart {
                ForEach(chartData, id: \.id) { item in
                    BarMark(
                        x: .value("date", item.date, unit: .day),
                        y: .value("price", item.price)
                    )
                }
            }
            .chartLegend(.visible)
            .frame(height: 250)
        }
        .foregroundStyle(.white)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.black.opacity(0.1))
        )
        .padding(.horizontal)
        .padding(.bottom)
    }
}

struct ExpenseFuelServiceChartView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Витрати")
                    .bold()
                Spacer()
            }
            
            Rectangle()
                .fill(.secondary)
                .frame(height: 1)
                .padding(.bottom, 8)
            
            HStack {
                Text("Авто")
                    .bold()
                    .foregroundStyle(.white)
                
                Spacer()
                
                Picker("Авто", selection: $viewModel.selectedCarID) {
                    
                    ForEach(viewModel.cars.map({ $0.id }), id: \.self) { id in
                        if let car = viewModel.cars.first(where: { $0.id == id }) {
                            Text(car.name).tag(id)
                        }
                    }
                }
                .tint(.white)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.white.opacity(0.1))
                )
                .onChange(of: viewModel.selectedCarID) { id in
                    guard let id, let car = viewModel.cars.first(where: { $0.id == id }) else { return }
                    viewModel.selectedCarForAnalytic = car
                    viewModel.updateChartAndTotalData(for: car)
                }
            }
            
            if let selectedCar = viewModel.selectedCarForAnalytic {
                TotalFuelServicePriceView(viewModel: viewModel)
                
                ZStack {
                    Text(String(Int(viewModel.calculateCarCost(selectedCar).rounded())))
                        .font(.title)
                        .bold()
                    
                    Chart {
                        ForEach(viewModel.chartDataForSectorChart, id: \.id) { data in
                            sectorMark(for: data)
                        }
                    }
                    .chartLegend(.visible)
                    .frame(height: 250)
                }
            }
        }
        .foregroundStyle(.white)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.black.opacity(0.1))
        )
        .padding(.horizontal)
        .padding(.bottom, 100)
    }
    
    private func sectorMark(for data: ExpensesChartItem) -> some ChartContent {
        SectorMark(
            angle: .value("cost", data.price),
            innerRadius: .ratio(0.8),
            angularInset: 8
        )
        .foregroundStyle(.white.opacity(0.3))
        .cornerRadius(5)
        .annotation(position: .overlay, alignment: .center) {
            Text("\(Int(data.price)) \(data.expenseType.rawValue)")
                .font(.title2)
                .bold()
                .foregroundStyle(.white)
        }
    }
}


struct TotalFuelServicePriceView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        let data: (Float, Float) = viewModel.totalFuelServicePriceForSelectedCar ?? (0, 0)
        
        VStack(spacing: 16) {
            HStack {
                Text("Витрачено коштів:")
                    .bold()
                
                Spacer()
            }
            
            HStack(spacing: 64) {
                VStack {
                    Text(String(Int(data.0)))
                        .font(.title)
                        .bold()
                    
                    Text("Пальне")
                        .bold()
                }
                
                VStack {
                    Text(String(Int(data.0)))
                        .font(.title)
                        .bold()
                    
                    Text("Сервіс")
                        .bold()
                }
            }
            .padding(32)
        }
    }
}

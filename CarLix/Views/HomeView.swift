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
                
                ScrollView {
                    LazyVStack {
                        DatePickerView(selectedDateType: $viewModel.selectedDateType)
                        
                        TotalAllCarsCostsView(viewModel: viewModel)
                        
                        ExpencesChartView(viewModel: viewModel)
                        
                        ExpenseFuelServiceChartView(viewModel: viewModel)
                    }
                }
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
                ForEach(0..<3) { i in
                    HStack {
                        Text("Audi A4 B8 2013")
                            
                        Spacer()
                        
                        Text("12 000")
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
    
    let testData = [
        (date: Date(), amount: 7, id: UUID().uuidString),
        (date: Date().addingTimeInterval(-86400), amount: 5, id: UUID().uuidString),
        (date: Date().addingTimeInterval(-2 * 86400), amount: 10, id: UUID().uuidString)
    ]
    
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
            
            Chart {
                ForEach(testData, id: \.id) { data in
                    BarMark(
                        x: .value("date", data.date),
                        y: .value("category", data.amount)
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
    
    let testData = [
        (date: Date(), amount: 7, id: UUID().uuidString),
        (date: Date().addingTimeInterval(-86400), amount: 5, id: UUID().uuidString),
        (date: Date().addingTimeInterval(-2 * 86400), amount: 10, id: UUID().uuidString)
    ]
    
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
                Text("Для авто")
                    .bold()
                Spacer()
                
                
            }
            
            Chart {
                ForEach(testData, id: \.id) { data in
                    SectorMark(angle: .value("cost", data.amount), innerRadius: .ratio(0.8), angularInset: 8)
                        .foregroundStyle(.white.opacity(0.3))
                        .cornerRadius(5)
                        .annotation(position: .overlay, alignment: .center) {
                            Text("\(data.date) \(data.amount)")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.white)
                        }
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
    }
}

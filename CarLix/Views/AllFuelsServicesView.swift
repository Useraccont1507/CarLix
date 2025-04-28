//
//  FuelsView.swift
//  CarLix
//
//  Created by Illia Verezei on 27.04.2025.
//

import SwiftUI

struct AllFuelsServicesView: View {
    @ObservedObject var viewModel: AllFuelsServicesViewModel
    
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
                    Spacer().frame(height: 120)
                    
                    if viewModel.isFuelPresented {
                        FuelsListView(viewModel: viewModel)
                            .blur(radius: viewModel.blur)
                    } else {
                        ServicesListView(viewModel: viewModel)
                            .blur(radius: viewModel.blur)
                    }
                }
                
                HeaderFuelsBar(viewModel: viewModel)
                    .blur(radius: viewModel.blur)
            }
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}

#Preview {
    AllFuelsServicesView(viewModel: AllFuelsServicesViewModel(blur: 0, isFuelPresented: false, coordiantor: nil, storage: nil))
}

struct HeaderFuelsBar: View {
    @ObservedObject var viewModel: AllFuelsServicesViewModel
    
    var body: some View {
            HStack {
                Text(viewModel.isFuelPresented ? "Пальне" : "Сервіс")
                    .font(.system(size: 46, weight: .bold))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Button {
                    viewModel.showAddFuelsServices()
                    print("action")
                } label: {
                    Image(systemName: "plus")
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
                .buttonStyle(.borderless)
            }
            .padding()
    }
}

struct FuelsListView: View {
    @ObservedObject var viewModel: AllFuelsServicesViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.cars, id: \.id) { car in
                VStack {
                    Text(car.name)
                        .bold()
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    let filtered = viewModel.fuels.filter({$0.carID == car.id})
                    
                    ForEach(filtered, id: \.id) { fuel in
                        VStack {
                            FuelRow(fuel: fuel)
                            
                            HStack {
                                Spacer()
                                
                                Button("Видалити") {
                                    viewModel.deleteFuel(fuel: fuel)
                                }
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background (
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.white.opacity(0.1))
                                )
                                .padding([.trailing, .bottom])
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(.black.opacity(0.1))
                        )
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
    }
}

struct ServicesListView: View {
    @ObservedObject var viewModel: AllFuelsServicesViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.cars, id: \.id) { car in
                VStack {
                    Text(car.name)
                        .bold()
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    let filtered = viewModel.services.filter({$0.carID == car.id})
                    
                    ForEach(filtered, id: \.id) { service in
                        VStack {
                            ServiceRow(service: service)
                            
                            HStack {
                                Spacer()
                                
                                Button("Видалити") {
                                    viewModel.deleteService(service: service)
                                }
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background (
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.white.opacity(0.1))
                                )
                                .padding([.trailing, .bottom])
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(.black.opacity(0.1))
                        )
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
    }
}

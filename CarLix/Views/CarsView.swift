//
//  CarsView.swift
//  CarLix
//
//  Created by Illia Verezei on 02.04.2025.
//

import SwiftUI

struct CarsView: View {
    @ObservedObject var viewModel: CarsViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [
                Color.grayGradient,
                Color.brownGradient,
                Color.graphiteGradient,
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack {
                HeaderBar(viewModel: viewModel)
                
                
                CarList(viewModel: viewModel)
                    .transition(.opacity)
            }
        }
        .overlay {
            ZStack {
                if viewModel.isLoadingViewPresented {
                    LoadingView()
                        .transition(.scale)
                }
                
                
            }
        }
        .animation(.smooth(duration: 0.5, extraBounce: 0.2), value: viewModel.isLoadingViewPresented)
        .animation(.smooth(duration: 0.5, extraBounce: 0.2), value: viewModel.cars)
        .onAppear {
            viewModel.loadCars()
        }
    }
}

#Preview {
    CarsView(viewModel: CarsViewModel())
}

struct HeaderBar: View {
    @ObservedObject var viewModel: CarsViewModel
    
    var body: some View {
        HStack {
            Text("MyCars")
                .font(.system(size: 46, weight: .bold))
                .foregroundStyle(.white)
            
            Spacer()
            
            Button {
                viewModel.moveToAdd()
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
        }
        .padding()
    }
}

struct CarList: View {
    @ObservedObject var viewModel: CarsViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.cars, id: \.id) { car in
                    ShortDescription(car: car, viewModel: viewModel)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
    }
    
}

struct ShortDescription: View {
    var car: Car
    @ObservedObject var viewModel: CarsViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            if let image = car.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
            } else {
                Image("DefaultCar")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text(car.name + " " + String(car.year))
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    HStack {
                        Text(car.engineName)
                            .font(.system(size: 18, weight: .regular))
                            .foregroundStyle(.white)
                        
                        Text(car.typeOfTransmission.rawValue.capitalized)
                            .font(.system(size: 18, weight: .regular))
                            .foregroundStyle(.white)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding(.horizontal)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.black.opacity(0.1))
        )
        .onTapGesture {
            viewModel.presentFullDescription(for: car)
        }
    }
}

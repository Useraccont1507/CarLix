//
//  FullDescriptionView.swift
//  CarLix
//
//  Created by Illia Verezei on 04.04.2025.
//

import SwiftUI

struct FullDescription: View {
    @ObservedObject var viewModel: CarsViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    if let car = viewModel.carToPresentFullDescription {
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
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text(car.name)
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .padding(.top)
                                
                                Spacer()
                                
                                Button {
                                    //
                                } label: {
                                    Text("ShowAll")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundStyle(.white)
                                        .padding(.horizontal)
                                        .padding(.vertical, 4)
                                        .background(
                                            RoundedRectangle(cornerRadius: 100)
                                                .fill(.white.opacity(0.1))
                                        )
                                }
                                .padding(.top)
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
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Button {
                        viewModel.moveToEdit()
                    } label: {
                        HStack {
                            Image(systemName: "pencil")
                                .foregroundStyle(.white)
                            Text("Редагувати інформацію")
                                .font(.callout)
                                .bold()
                                .foregroundStyle(.white)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundStyle(.orange)
                    )
                    
                    Button {
                        viewModel.blurForFullDescription = 10
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
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundStyle(.red)
                    )
                }
               .padding()
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 500)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.white.opacity(0.1))
        )
    }
}


#Preview {
    ZStack {
        Color.black.opacity(0.5)
            .ignoresSafeArea()
        FullDescription(viewModel: CarsViewModel())
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

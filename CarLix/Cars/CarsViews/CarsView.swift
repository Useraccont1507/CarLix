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
            .blur(radius: viewModel.blur)
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
                
                if viewModel.isFullDescriprionPresented {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                    
                    ExitButton(viewModel: viewModel)
                        .padding()
                        .transition(.move(edge: .trailing))
                        .blur(radius: viewModel.blurForFullDescription)
                    
                    FullDescription(viewModel: viewModel)
                        .padding()
                        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .offset(y: 1000)))
                        .blur(radius: viewModel.blurForFullDescription)
                }
                
                
                
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
        .animation(.smooth(duration: 0.5, extraBounce: 0.2), value: viewModel.isLoadingViewPresented)
        .animation(.smooth(duration: 0.5, extraBounce: 0.2), value: viewModel.cars)
        .animation(.smooth(duration: 0.5, extraBounce: 0.2), value: viewModel.isFullDescriprionPresented)
        .animation(.smooth(duration: 0.5, extraBounce: 0.2), value: viewModel.deleteStatusState)
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
                viewModel.blur = 10
                viewModel.presentFullDescription(for: car)
            }
    }
}

struct ExitButton: View {
    @ObservedObject var viewModel: CarsViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    viewModel.hideFullDescription()
                    viewModel.blur = 0
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.5))
                        .background(
                            Circle()
                                .fill(.black.opacity(0.1))
                                .frame(width: 50, height: 50)
                        )
                        .frame(width: 40, height: 40)
                }
            }
            Spacer()
        }
    }
}

struct DeleteAlertView: View {
    @ObservedObject var viewModel: CarsViewModel
    
    var body: some View {
        VStack {
            VStack {
                Text("Ви точно бажаєте видалити авто?")
                Text("Усі записи будуть втрачені")
            }
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.bottom)
            
            HStack(spacing: 16) {
                Button {
                    print("Action")
                    viewModel.blurForFullDescription = 0
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
    @ObservedObject var viewModel: CarsViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Авто було видалено")
                .foregroundStyle(.white)
                .bold()
            
            Button {
                viewModel.deleteStatusState = .notTapped
                viewModel.isFullDescriprionPresented = false
                viewModel.blurForFullDescription = 0
                viewModel.blur = 0
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
    @ObservedObject var viewModel: CarsViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Упс. Щось пішло не так.\nСпробуйте пізніше")
                .multilineTextAlignment(.center)
                .bold()
                .foregroundStyle(.white)
            
            Button {
                viewModel.blurForFullDescription = 0
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

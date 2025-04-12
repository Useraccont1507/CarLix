//
//  FirstGreeting.swift
//  CarLix
//
//  Created by Illia Verezei on 17.03.2025.
//

import SwiftUI

struct FirstGreeting: View {
    @ObservedObject var viewModel: FirstGreetingViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [
                Color.grayGradient,
                Color.brownGradient,
                Color.graphiteGradient,
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack {
                ZStack {
                    switch viewModel.greetingStep {
                    case .begin:
                        BeginView()
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    case .addCar:
                        AddCarsView()
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    case .addFuelingAndService:
                        AddFuelingAndServiceView()
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    case .carHistory:
                        TrackCarHistoryView()
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    case .receiveNotification:
                        ReceiveNotificationView(viewModel: viewModel)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    case .end:
                        EndView()
                    }
                }
                .blur(radius: viewModel.blur)
                .animation(.easeIn, value: viewModel.greetingStep)
                
                NextButtonView(viewModel: viewModel)
                    .blur(radius: viewModel.blur)
            }
            .overlay {
                if viewModel.notificationAlertState {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            AllowNotificationView(viewModel: viewModel)
                            .transition(.asymmetric(insertion: .scale, removal: .scale))
                    }
                } else if viewModel.notificationDismissedAlertState {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        NotificationWasDeniedView(viewModel: viewModel)
                            .transition(.asymmetric(insertion: .scale, removal: .move(edge: .leading)))
                            .padding()
                    }
                }
            }
            .animation(.easeIn, value: viewModel.notificationAlertState)
            .animation(.easeIn, value: viewModel.notificationDismissedAlertState)
        }
    }
}

#Preview {
    FirstGreeting(viewModel: FirstGreetingViewModel(coordinator: AppCoordinator()))
}

struct BeginView: View {
    var body: some View {
        GeometryReader { proxy in
            VStack {
                VStack(alignment: .leading) {
                    Text("welcomeLocalized")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.white)
                        .padding(.bottom)
                    
                    Text("descriptionLocalized")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Image("CarLixLabel")
                    .resizable()
                    .frame(width: proxy.size.width * 0.6, height: proxy.size.height * 0.1)
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

struct AddCarsView: View {
    var body: some View {
        GeometryReader { proxy in
            VStack {
                VStack(alignment: .leading) {
                    Text("AddingCarLocalized")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.white)
                        .padding(.bottom)
                    
                    Text("TrackHistoryLocalized")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Image("CarLixLabel")
                    .resizable()
                    .frame(width: proxy.size.width * 0.6, height: proxy.size.height * 0.1)
                    .foregroundStyle(.white)
                
                Spacer()
                
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

struct AddFuelingAndServiceView: View {
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Text("AddFuilengServiceAndLocalized")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.white)
                    .padding(.bottom)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Image("CarLixLabel")
                    .resizable()
                    .frame(width: proxy.size.width * 0.6, height: proxy.size.height * 0.1)
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

struct TrackCarHistoryView: View {
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Text("TrackCarHistoryViewLocalized")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.white)
                    .padding(.bottom)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Image("CarLixLabel")
                    .resizable()
                    .frame(width: proxy.size.width * 0.6, height: proxy.size.height * 0.1)
                    .foregroundStyle(.white)
                
                Spacer()
                
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

struct ReceiveNotificationView: View {
    @ObservedObject var viewModel: FirstGreetingViewModel
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center) {
                Text("ReceiveNotificationLocalized")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.white)
                    .padding(.bottom)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Image("CarLixLabel")
                    .resizable()
                    .frame(width: proxy.size.width * 0.6, height: proxy.size.height * 0.1)
                    .foregroundStyle(.white)
                
                Spacer()
                
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

struct AllowNotificationView: View {
    @ObservedObject var viewModel: FirstGreetingViewModel
    
    var body: some View {
        ZStack {
            VStack {
                Image("BellIcon")
                    .resizable()
                    .frame(width: 46, height: 46)
                    .foregroundStyle(.white)
                    .padding(.bottom, 24)
                Text("AddPermission")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .padding(.bottom, 24)
                
                Button {
                    viewModel.nextStep()
                } label: {
                    Text("ок".uppercased())
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.vertical)
                        .padding(.horizontal, 32)
                        .background(
                            RoundedRectangle(cornerRadius: 100)
                                .foregroundStyle(.white.opacity(0.1))
                        )
                }
            }
            .padding()
            .padding(.top, 40)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .foregroundStyle(.white.opacity(0.1))
            )
        }
    }
}

struct NotificationWasDeniedView: View {
    @ObservedObject var viewModel: FirstGreetingViewModel
    
    var body: some View {
        VStack {
            Text("WeRecomend")
                .font(.callout)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .padding(.bottom, 24)
            
            Button {
                viewModel.nextStep()
            } label: {
                Text("ок".uppercased())
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.vertical)
                    .padding(.horizontal, 32)
                    .background(
                        RoundedRectangle(cornerRadius: 100)
                            .foregroundStyle(.white.opacity(0.1))
                    )
            }
        }
        .padding()
        .padding(.top, 40)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(.white.opacity(0.1))
        )
    }
}

struct EndView: View {
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text("LookAfterCar")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.white)
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                
                Image("CarLixLabel")
                    .resizable()
                    .frame(width: proxy.size.width * 0.6, height: proxy.size.height * 0.1)
                    .foregroundStyle(.white)
                
                Spacer()
                
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

struct NextButtonView: View {
    @ObservedObject var viewModel: FirstGreetingViewModel
    
    var body: some View {
        Button {
            viewModel.nextStep()
        } label: {
            HStack {
                Text("Далі")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.vertical, 20)
                    .padding(.leading, 20)
                Image(systemName: "arrow.right")
                    .foregroundStyle(.white)
                    .padding(.trailing, 20)
            }
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .foregroundStyle(.white.opacity(0.1))
            )
        }
        .padding()
    }
}

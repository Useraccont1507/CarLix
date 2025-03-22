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
            LinearGradient(colors: [.mint, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack {
                ZStack {
                    switch viewModel.greetingStep {
                    case .begin:
                        BeginView()
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    case .addCar:
                        AddCarView()
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
                .animation(.easeIn, value: viewModel.greetingStep)
                
                NextButtonView(viewModel: viewModel)
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
                        .font(.system(size: 46, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.white)
                        .padding(.vertical)
                    
                    Text("descriptionLocalized")
                        .font(.system(size: 20, weight: .semibold))
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

struct AddCarView: View {
    var body: some View {
        GeometryReader { proxy in
            VStack {
                VStack(alignment: .leading) {
                    Text("AddingCarLocalized")
                        .font(.system(size: 46, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.white)
                        .padding(.vertical)
                    
                    Text("TrackHistoryLocalized")
                        .font(.system(size: 20, weight: .semibold))
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
                    .font(.system(size: 46, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.white)
                    .padding(.vertical)
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
                        .font(.system(size: 46, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.white)
                        .padding(.vertical)
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
                    .font(.system(size: 46, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.white)
                    .padding(.vertical)
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
        VStack {
            Text("🔔")
                .font(.system(size: 32, weight: .bold))
                .padding(.bottom, 4)
            Text("AddPermission")
                .font(.system(size: 16, weight: .regular))
                .multilineTextAlignment(.center)
                .foregroundStyle(.darkGreyText)
                .padding(.bottom, 4)
            
            Button {
                viewModel.nextStep()
            } label: {
                Text("ок".uppercased())
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.mint)
                    )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.white)
        )
    }
}

struct NotificationWasDeniedView: View {
    @ObservedObject var viewModel: FirstGreetingViewModel
    
    var body: some View {
        VStack {
            Text("WeRecomend")
                .font(.system(size: 16, weight: .regular))
                .multilineTextAlignment(.center)
                .foregroundStyle(.darkGreyText)
                .padding(.bottom, 4)
            
            Button {
                viewModel.nextStep()
            } label: {
                Text("ок".uppercased())
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.mint)
                    )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.white)
        )
    }
}

struct EndView: View {
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text("LookAfterCar")
                        .font(.system(size: 46, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.white)
                        .padding(.vertical)
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
                Text("Next")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.vertical)
                    .padding(.leading)
                Image(systemName: "arrow.right")
                    .foregroundStyle(.white)
                    .padding(.trailing)
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.mint)
            )
        }
        .padding()
    
    }
}

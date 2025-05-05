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
                
                Spacer()
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

//
//  ViewingOrEditCar.swift
//  CarLix
//
//  Created by Illia Verezei on 11.04.2025.
//

import SwiftUI

struct ViewingCar: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [
                Color.grayGradient,
                Color.brownGradient,
                Color.graphiteGradient,
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack {
                
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(.black.opacity(0.1))
            )
        }
    }
}

#Preview {
    ViewingCar()
}

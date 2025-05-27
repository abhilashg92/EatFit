//
//  SplashView.swift
//  EatFit
//
//  Created by Abhilash Ghogale on 27/05/25.
//

import SwiftUI

// MARK: - SplashView
/// The initial splash screen shown on app launch.
struct SplashView: View {
    @StateObject private var viewModel = SplashViewModel()
    @State private var showHome = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            VStack(spacing: 24) {
                Image(systemName: "leaf.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.green)
                    .shadow(radius: 10)
                Text("EatFit")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text("Eat healthy, stay fit!")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onReceive(viewModel.$shouldNavigate) { shouldNavigate in
            if shouldNavigate {
                // Debug log for navigation
                print("[DEBUG] SplashView: Navigating to HomeView.")
                showHome = true
            }
        }
        .fullScreenCover(isPresented: $showHome) {
            HomeView()
        }
    }
}

// MARK: - Preview
struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
} 
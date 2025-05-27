//
//  HomeView.swift
//  EatFit
//
//  Created by Abhilash Ghogale on 27/05/25.
//

import SwiftUI

// MARK: - HomeView
/// The main home screen after splash.
/// Uses HomeViewModel defined in the same module.
struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(spacing: 32) {
            Image(systemName: "house.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Welcome to EatFit!")
                .font(.title)
                .fontWeight(.semibold)
            Button(action: {
                print("[DEBUG] HomeView: Click Food button tapped.")
                viewModel.clickFoodButtonTapped()
            }) {
                Text("Click Food")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
                    .shadow(radius: 4)
            }
            .padding(.horizontal, 32)
            // Show preview if image is captured
            if let image = viewModel.capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(16)
                    .shadow(radius: 4)
                    .padding(.top, 16)
            }
        }
        .padding()
        .sheet(isPresented: $viewModel.showCamera, onDismiss: {
            print("[DEBUG] HomeView: Camera sheet dismissed.")
            viewModel.handleCapturedImage(viewModel.capturedImage)
        }) {
            CameraView(image: $viewModel.capturedImage)
        }
    }
}

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
} 
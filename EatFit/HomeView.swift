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
            if let image = viewModel.capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(16)
                    .shadow(radius: 4)
                    .padding(.top, 16)
                HStack(spacing: 16) {
                    Button(action: {
                        Task { await viewModel.analyzeFood() }
                    }) {
                        Text("Analyze Food")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                            .shadow(radius: 4)
                    }
                    Button(action: {
                        // Retake photo
                        viewModel.capturedImage = nil
                        viewModel.showSourceActionSheet = true
                    }) {
                        Text("Retake Photo")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(12)
                            .shadow(radius: 4)
                    }
                }
                .padding(.horizontal, 16)
                if viewModel.isAnalyzing {
                    ProgressView("Analyzing food...")
                        .padding()
                }
                if let error = viewModel.analysisError {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                if let result = viewModel.analysisResult {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(result.name)
                            .font(.headline)
                            .padding(.bottom, 4)
                        Text("🧂 Ingredients: \(result.ingredients.joined(separator: ", "))")
                        Text("🔥 Calories: \(result.calories) kcal")
                        Text("🍚 Carbohydrates: \(result.carbohydrates) g")
                        Text("🥩 Protein: \(result.protein) g")
                        Text("🧈 Fat: \(result.fat) g")
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    .padding(.top, 8)
                }
            } else {
                Image(systemName: "house.fill")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Welcome to EatFit!")
                    .font(.title)
                    .fontWeight(.semibold)
                Button(action: {
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
            }
        }
        .padding()
        .actionSheet(isPresented: $viewModel.showSourceActionSheet) {
            ActionSheet(title: Text("Select Image Source"), buttons: [
                .default(Text("Camera")) { viewModel.selectImageSource(.camera) },
                .default(Text("Photo Library")) { viewModel.selectImageSource(.photoLibrary) },
                .cancel()
            ])
        }
        .sheet(isPresented: $viewModel.showCamera, onDismiss: {
            viewModel.handleCapturedImage(viewModel.capturedImage)
        }) {
            CameraView(image: $viewModel.capturedImage, sourceType: viewModel.imageSource == .camera ? .camera : .photoLibrary)
        }
    }
}

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
} 
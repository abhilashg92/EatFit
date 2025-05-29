//
//  HomeViewModel.swift
//  EatFit
//
//  Created by Abhilash Ghogale on 27/05/25.
//

import Foundation
import SwiftUI

// MARK: - HomeViewModel
/// ViewModel for HomeView, manages UI state and actions.
final class HomeViewModel: ObservableObject {
    // Published property to trigger camera sheet
    @Published var showCamera: Bool = false
    
    // Published property to hold the captured image
    @Published var capturedImage: UIImage? = nil
    
    // Enum for image source
    enum ImageSourceType {
        case camera
        case photoLibrary
    }
    
    // Published property to track image source
    @Published var imageSource: ImageSourceType = .camera

    // Show action sheet for source selection
    @Published var showSourceActionSheet: Bool = false
    
    // MARK: - Food Analysis State
    @Published var isAnalyzing: Bool = false
    @Published var analysisResult: FoodAnalysisResult? = nil
    @Published var analysisError: String? = nil

    // MARK: - In-memory History
    @Published var history: [FoodAnalysisResult] = []

    private let analyzerService = FoodAnalyzerService()

    /// Handles the action when the user taps the Click Food button.
    func clickFoodButtonTapped() {
        // Debug log for button tap
        print("[DEBUG] HomeViewModel: Click Food button tapped.")
        showSourceActionSheet = true
    }
    
    /// Set the image source and show the picker
    func selectImageSource(_ source: ImageSourceType) {
        imageSource = source
        showCamera = true
        showSourceActionSheet = false
    }
    
    /// Handles the image received from the camera.
    func handleCapturedImage(_ image: UIImage?) {
        // Debug log for image received
        print("[DEBUG] HomeViewModel: Received image from camera.")
        capturedImage = image
        showCamera = false
    }

    /// Triggers food analysis using the captured image.
    @MainActor
    func analyzeFood() async {
        guard let image = capturedImage else { return }
        isAnalyzing = true
        analysisError = nil
        analysisResult = nil
        do {
            let result = try await analyzerService.analyzeFoodWithGemini(image: image)
            analysisResult = result
            history.insert(result, at: 0)
            print("[DEBUG] HomeViewModel: Analysis result received and added to history.")
        } catch {
            analysisError = error.localizedDescription
            print("[DEBUG] HomeViewModel: Analysis failed: \(error.localizedDescription)")
        }
        isAnalyzing = false
    }
} 
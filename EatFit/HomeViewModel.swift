//
//  HomeViewModel.swift
//  EatFit
//
//  Created by Abhilash Ghogale on 27/05/25.
//

import Foundation
import SwiftUI
import UIKit

// MARK: - HomeViewModel
/// ViewModel for HomeView, manages UI state and actions.
final class HomeViewModel: ObservableObject {
    // Published property to trigger camera sheet
    @Published var showCamera: Bool = false
    
    // Published property to hold the captured image
    @Published var capturedImage: UIImage? = nil
    
    /// Handles the action when the user taps the Click Food button.
    func clickFoodButtonTapped() {
        // Debug log for button tap
        print("[DEBUG] HomeViewModel: Click Food button tapped.")
        showCamera = true
    }
    
    /// Handles the image received from the camera.
    func handleCapturedImage(_ image: UIImage?) {
        // Debug log for image received
        print("[DEBUG] HomeViewModel: Received image from camera.")
        capturedImage = image
        showCamera = false
    }
} 
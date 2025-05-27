//
//  FoodAnalyzerService.swift
//  EatFit
//
//  Created by Abhilash Ghogale on 27/05/25.
//

import Foundation
import UIKit

// MARK: - FoodAnalyzerService
/// Service responsible for sending food images to the OpenAI API and parsing the response.
final class FoodAnalyzerService {
    // Placeholder for your OpenAI API key
    private let apiKey = "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"
    private let apiURL = URL(string: "https://api.openai.com/v1/food/analyze")! // Replace with actual endpoint
    
    /// Analyzes the given food image using the real API.
    /// - Parameter image: The UIImage to analyze.
    /// - Returns: A FoodAnalysisResult if successful.
    func analyzeFood(image: UIImage) async throws -> FoodAnalysisResult {
        // Debug log for API call
        print("[DEBUG] FoodAnalyzerService: Sending image to OpenAI API.")
        // Prepare request (mocked, replace with real implementation)
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // TODO: Add multipart/form-data or base64 image encoding as required by the API
        // For now, throw not implemented
        throw NSError(domain: "FoodAnalyzerService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Real API integration not implemented. Replace with actual request body and parsing."])
    }
    
    /// Returns a mock analysis result for testing UI.
    /// - Returns: A FoodAnalysisResult with sample or invalid data.
    func mockAnalysisResult() -> FoodAnalysisResult {
        print("[DEBUG] FoodAnalyzerService: Returning mock analysis result.")
        let mockResults: [FoodAnalysisResult] = [
            FoodAnalysisResult(name: "Grilled Chicken Bowl", ingredients: ["Chicken", "Rice", "Broccoli", "Olive Oil"], calories: 420, carbohydrates: 55, protein: 30, fat: 12, imageData: nil),
            FoodAnalysisResult(name: "Salmon Quinoa Plate", ingredients: ["Salmon", "Quinoa", "Spinach"], calories: 390, carbohydrates: 40, protein: 28, fat: 14, imageData: nil),
            FoodAnalysisResult(name: "Avocado Toast", ingredients: ["Eggs", "Avocado", "Toast"], calories: 320, carbohydrates: 30, protein: 18, fat: 16, imageData: nil),
            FoodAnalysisResult(name: "Beef Stew", ingredients: ["Beef", "Potato", "Carrot"], calories: 510, carbohydrates: 60, protein: 35, fat: 20, imageData: nil),
            FoodAnalysisResult(name: "Cheesy Pasta", ingredients: ["Pasta", "Tomato Sauce", "Cheese"], calories: 470, carbohydrates: 70, protein: 15, fat: 10, imageData: nil),
            FoodAnalysisResult(name: "Tofu Power Bowl", ingredients: ["Tofu", "Brown Rice", "Peas"], calories: 350, carbohydrates: 50, protein: 20, fat: 8, imageData: nil),
            FoodAnalysisResult(name: "Turkey Dinner", ingredients: ["Turkey", "Sweet Potato", "Green Beans"], calories: 400, carbohydrates: 45, protein: 32, fat: 9, imageData: nil),
            FoodAnalysisResult(name: "Shrimp Couscous", ingredients: ["Shrimp", "Couscous", "Zucchini"], calories: 330, carbohydrates: 38, protein: 25, fat: 7, imageData: nil),
            // Invalid: missing ingredients, all values zero
            FoodAnalysisResult(name: "Unknown Dish", ingredients: [], calories: 0, carbohydrates: 0, protein: 0, fat: 0, imageData: nil),
            // Invalid: negative values
            FoodAnalysisResult(name: "Mystery", ingredients: ["Mystery"], calories: -1, carbohydrates: -1, protein: -1, fat: -1, imageData: nil)
        ]
        return mockResults.randomElement()!
    }
} 

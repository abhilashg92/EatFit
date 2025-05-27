//
//  FoodAnalysisResult.swift
//  EatFit
//
//  Created by Abhilash Ghogale on 27/05/25.
//

import Foundation

// MARK: - FoodAnalysisResult
/// Model representing the result of food analysis.
struct FoodAnalysisResult: Codable, Identifiable {
    let id = UUID()
    let name: String
    let ingredients: [String]
    let calories: Int
    let carbohydrates: Int
    let protein: Int
    let fat: Int
} 
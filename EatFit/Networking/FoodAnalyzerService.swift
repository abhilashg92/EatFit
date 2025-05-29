//
//  FoodAnalyzerService.swift
//  EatFit
//
//  Created by Abhilash Ghogale on 27/05/25.
//

import Foundation
import UIKit
import Security

// MARK: - FoodAnalyzerService
/// Service responsible for sending food images to the OpenAI API and parsing the response.
final class FoodAnalyzerService {
    private let apiKeyKeychainKey = Bundle.main.infoDictionary?["GEMINI_API_KEY"] as? String ?? "" 

    private let apiURL = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=")! // Append API key at runtime
    
    // MARK: - Keychain Helpers
    func saveAPIKeyToKeychain(_ apiKey: String) {
        let keyData = apiKey.data(using: .utf8) ?? Data()
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: apiKeyKeychainKey,
            kSecValueData as String: keyData
        ]
        SecItemDelete(query as CFDictionary) // Remove old key if exists
        SecItemAdd(query as CFDictionary, nil)
    }

    func getAPIKeyFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: apiKeyKeychainKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess, let data = dataTypeRef as? Data, let apiKey = String(data: data, encoding: .utf8) {
            return apiKey
        }
        return nil
    }

    private func constructPrompt(imageMimeType: String) -> String {
        return """
        Analyze the food items in the provided image (\(imageMimeType)).
        Identify the main dish name if discernible.
        List all visible ingredients. For each ingredient, provide its name and an estimated quantity if possible (e.g., \"100g\", \"1 cup\", \"1 slice\"). If quantity is not determinable, use null for quantity.
        Estimate the overall nutritional information for the dish or primary food items. Provide values for:
        - calories (in kcal)
        - protein (in grams)
        - fat (in grams)
        - carbohydrates (in grams)
        If any nutritional value cannot be reasonably estimated, use null for that specific value.

        Return your response strictly as a JSON object with the following structure:
        {
          \"dishName\": \"string | null (name_of_the_dish_if_identifiable)\",
          \"ingredients\": [
            {\"name\": \"string (ingredient_name)\", \"quantity\": \"string | null (estimated_quantity)\"}
          ],
          \"nutrition\": {
            \"calories\": \"number | null (total_kcal)\",
            \"protein\": \"number | null (grams)\",
            \"fat\": \"number | null (grams)\",
            \"carbohydrates\": \"number | null (grams)\"
          }
        }

        Ensure the output is ONLY the JSON object, without any markdown fences (like ```json ... ```) or explanatory text surrounding it.
        The entire response must be a single, valid JSON object.
        """
    }

    struct GeminiIngredient: Codable {
        let name: String
        let quantity: String?
    }

    struct GeminiNutrition: Codable {
        let calories, protein, fat, carbohydrates: String? // Changed to optional String
    }

    struct GeminiResponse: Codable {
        let dishName: String?
        let ingredients: [GeminiIngredient]
        let nutrition: GeminiNutrition
    }

    /// Analyzes the given food image using the real API.
    /// - Parameter image: The UIImage to analyze.
    /// - Returns: A FoodAnalysisResult if successful.
    // (Old analyzeFood(image:) method removed)
    
    /// Returns a mock analysis result for testing UI.
    /// - Returns: A FoodAnalysisResult with sample or invalid data.
    func mockAnalysisResult() -> FoodAnalysisResult {
        print("[DEBUG] FoodAnalyzerService: Returning mock analysis result.")
        let mockResults: [FoodAnalysisResult] = [
            FoodAnalysisResult(name: "Grilled Chicken Bowl", ingredients: ["Chicken", "Rice", "Broccoli", "Olive Oil"], calories: "420", carbohydrates: "55", protein: "30", fat: "12", imageData: nil),
            FoodAnalysisResult(name: "Salmon Quinoa Plate", ingredients: ["Salmon", "Quinoa", "Spinach"], calories: "390", carbohydrates: "40", protein: "28", fat: "14", imageData: nil),
            FoodAnalysisResult(name: "Avocado Toast", ingredients: ["Eggs", "Avocado", "Toast"], calories: "320", carbohydrates: "30", protein: "18", fat: "16", imageData: nil)
        ]
        return mockResults.randomElement()!
    }

    init() {
        // Save the API key to Keychain only if not already present
        let key = getAPIKeyFromKeychain()
        if key == nil || key?.isEmpty == true {
            saveAPIKeyToKeychain("AIzaSyAj-bKBp3lX1_gJNoj2U8_ijtgAfU9GV9E")
        }
    }

    func analyzeFoodWithGemini(image: UIImage) async throws -> FoodAnalysisResult {
        guard let apiKey = getAPIKeyFromKeychain(), !apiKey.isEmpty else {
            throw NSError(domain: "FoodAnalyzerService", code: -10, userInfo: [NSLocalizedDescriptionKey: "Gemini API key not found in Keychain."])
        }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "FoodAnalyzerService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to encode image"])
        }
        let base64String = imageData.base64EncodedString()
        let imageMimeType = "image/jpeg"
        let prompt = constructPrompt(imageMimeType: imageMimeType)

        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        [
                            "inlineData": [
                                "mimeType": imageMimeType,
                                "data": base64String
                            ]
                        ],
                        [
                            "text": prompt
                        ]
                    ]
                ]
            ]
        ]

        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        let urlWithKey = URL(string: apiURL.absoluteString + apiKey)! // Append key to URL
        var request = URLRequest(url: urlWithKey)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.upload(for: request, from: jsonData)
        debugPrint("[DEBUG] Gemini response \(response)")
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw NSError(domain: "FoodAnalyzerService", code: -3, userInfo: [NSLocalizedDescriptionKey: "Invalid response from Gemini API"])
        }
        guard  let dish = parseGeminiResponse(json) else {
                        throw NSError(domain: "FoodAnalyzerService", code: -4, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response"])

        }
        
        return FoodAnalysisResult(
            name: dish.dishName ?? "Unknown Dish",
            ingredients: dish.ingredients.map { $0.name },
            calories: dish.nutrition.calories ?? "",
            carbohydrates: dish.nutrition.carbohydrates ?? "",
            protein: dish.nutrition.protein ?? "" ,
            fat: dish.nutrition.fat ?? "",
            imageData: imageData
        )
    }
    
    func parseGeminiResponse(_ response: [String: Any]) -> GeminiDishResponse? {
        guard
            let candidates = response["candidates"] as? [[String: Any]],
            let content = candidates.first?["content"] as? [String: Any],
            let parts = content["parts"] as? [[String: Any]],
            let text = parts.first?["text"] as? String
        else {
            print("Invalid Gemini response format")
            return nil
        }

        // Remove triple backticks and optional 'json' marker
        let cleanedText = text
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // Convert to Data and decode
        guard let jsonData = cleanedText.data(using: .utf8) else {
            print("Failed to convert cleaned text to Data")
            return nil
        }

        do {
            let decoded = try JSONDecoder().decode(GeminiDishResponse.self, from: jsonData)
            return decoded
        } catch {
            print("Decoding failed: \(error)")
            return nil
        }
    }

}

struct GeminiDishResponse: Codable {
    let dishName: String?
    let ingredients: [Ingredient]
    let nutrition: Nutrition
}

struct Ingredient: Codable {
    let name: String
    let quantity: String?
}

struct Nutrition: Codable {
    let calories: String?
    let protein: String?
    let fat: String?
    let carbohydrates: String?
}

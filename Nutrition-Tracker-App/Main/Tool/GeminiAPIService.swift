//
//  GeminiAPIService.swift
//  Nutrition-Tracker-App
//
//  Created by Hoi Mau Tan on 9/24/25.
//

import SwiftUI
import Combine
import GoogleGenerativeAI

@MainActor
class GeminiAPIService: ObservableObject {
    
    // MARK: - Published Properties
    @Published var recognizedFood: FoodLogItem?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    private var generativeModel: GenerativeModel?
    
    // MARK: - Initialization
    init() {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "GeminiAPIKey") as? String else {
             errorMessage = "Could not find API key in Info.plist"
             return
         }
         
         guard !apiKey.isEmpty, apiKey != "YOUR_API_KEY_HERE" else {
             errorMessage = "API key is missing. Please add it to Keys.xcconfig"
             return
         }
         
         generativeModel = GenerativeModel(name: "gemini-2.5-flash", apiKey: apiKey)
     }
    
    // MARK: - Public Methods
    // GeminiAPIService.swift
    
    func recognizeFood(from image: UIImage) {
        guard let model = generativeModel else {
            errorMessage = "Generative model not initialized."
            return
        }
        
        isLoading = true
        errorMessage = nil
        recognizedFood = nil
        
        Task {
            do {
                let prompt = """
                Analyze the image and identify the primary food item. Provide a nutritional estimate for a single serving.
                Respond ONLY in JSON format with the following keys: "name" (String), "calories" (Int), "protein" (Int), "carbs" (Int), "fat" (Int).
                Do not include any other text or markdown formatting.
                """
                
                let response = try await model.generateContent(prompt, image)
                
                guard var text = response.text else {
                    throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format from Gemini."])
                }
                
                // --- FIX IS HERE ---
                // 1. Print the raw response for debugging
                print("Gemini Raw Response: \(text)")
                
                // 2. Extract the JSON block from the text
                if let jsonStartIndex = text.firstIndex(of: "{"), let jsonEndIndex = text.lastIndex(of: "}") {
                    let jsonSubstring = text[jsonStartIndex...jsonEndIndex]
                    text = String(jsonSubstring)
                }
                
                guard let jsonData = text.data(using: .utf8) else {
                    throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not convert cleaned text to data."])
                }
                // --- END OF FIX ---
                
                let decoder = JSONDecoder()
                let decodableFoodItem = try decoder.decode(DecodableFoodLogItem.self, from: jsonData)
                
                self.recognizedFood = FoodLogItem(
                    name: decodableFoodItem.name,
                    calories: decodableFoodItem.calories,
                    protein: decodableFoodItem.protein,
                    carbs: decodableFoodItem.carbs,
                    fat: decodableFoodItem.fat,
                    timestamp: .now
                )
                
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
}

// A temporary decodable struct to match the JSON response from Gemini
private struct DecodableFoodLogItem: Decodable {
    let name: String
    let calories: Int
    let protein: Int
    let carbs: Int
    let fat: Int
}

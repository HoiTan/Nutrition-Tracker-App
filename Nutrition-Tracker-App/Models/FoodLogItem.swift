//
//  FoodLogItem.swift
//  Nutrition-Tracker-App
//
//  Created by Hoi Mau Tan on 9/23/25.
//

import Foundation
import SwiftData

@Model
final class FoodLogItem {
    var name: String
    var calories: Int
    var protein: Int
    var carbs: Int
    var fat: Int
    var servings: Double
    var timestamp: Date
    
    init(name: String, calories: Int, protein: Int, carbs: Int, fat: Int, servings: Double = 1.0, timestamp: Date) {
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.servings = servings
        self.timestamp = timestamp
    }
    // Calculated properties for total nutrition based on servings
    @Transient var totalCalories: Int { Int(Double(calories) * servings) }
    @Transient var totalProtein: Int { Int(Double(protein) * servings) }
    @Transient var totalCarbs: Int { Int(Double(carbs) * servings) }
    @Transient var totalFat: Int { Int(Double(fat) * servings) }
}

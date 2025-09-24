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
    var timestamp: Date
    
    init(name: String, calories: Int, protein: Int, carbs: Int, fat: Int, timestamp: Date) {
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.timestamp = timestamp
    }
}

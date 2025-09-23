//
//  UserProfile.swift
//  Nutrition-Tracker-App
//
//  Created by Hoi Mau Tan on 9/22/25.
//

import Foundation

// Enum for Gender
enum Gender: String, CaseIterable, Identifiable {
    case male = "Male"
    case female = "Female"
    case preferNotToSay = "Prefer Not to Say"
    var id: Self { self }
}

// Enum for Activity Level
enum ActivityLevel: String, CaseIterable, Identifiable {
    case sedentary = "Sedentary"
    case lightlyActive = "Lightly Active"
    case moderatelyActive = "Moderately Active"
    case veryActive = "Very Active"
    var id: Self { self }
}

// Enum for Goal
enum Goal: String, CaseIterable, Identifiable {
    case loseWeight = "Lose Weight"
    case gainWeight = "Gain Weight"
    case maintainWeight = "Maintain Weight"
    var id: Self { self }
}

// Main User Profile Struct
struct UserProfile {
    var age: Int = 20
    var gender: Gender = .preferNotToSay
    var height: Double = 175 // in cm
    var currentWeight: Double = 75 // in kg
    var activityLevel: ActivityLevel = .lightlyActive

    var goal: Goal = .maintainWeight
    var goalWeight: Double = 75 // in kg

    // Calculated Properties for Calorie Target
    var bmr: Double {
        // Harris-Benedict Equation for BMR calculation
        let weightInKg = currentWeight
        let heightInCm = height
        if gender == .male {
            return 88.362 + (13.397 * weightInKg) + (4.799 * heightInCm) - (5.677 * Double(age))
        } else {
            return 447.593 + (9.247 * weightInKg) + (3.098 * heightInCm) - (4.330 * Double(age))
        }
    }

    var tdee: Double {
        // TDEE calculation based on activity level
        switch activityLevel {
        case .sedentary:
            return bmr * 1.2
        case .lightlyActive:
            return bmr * 1.375
        case .moderatelyActive:
            return bmr * 1.55
        case .veryActive:
            return bmr * 1.725
        }
    }

    var recommendedCalories: Int {
        switch goal {
        case .loseWeight:
            return Int(tdee - 500) // Deficit of 500 calories for ~1lb/week loss
        case .maintainWeight:
            return Int(tdee)
        case .gainWeight:
            return Int(tdee + 500) // Surplus of 500 calories
        }
    }
}

import Foundation
import SwiftData

// Enums remain the same (must be Codable)
enum Gender: String, Codable, CaseIterable, Identifiable {
    case male = "Male"
    case female = "Female"
    case preferNotToSay = "Prefer Not to Say"
    var id: Self { self }
}

enum ActivityLevel: String, Codable, CaseIterable, Identifiable {
    case sedentary = "Sedentary"
    case lightlyActive = "Lightly Active"
    case moderatelyActive = "Moderately Active"
    case veryActive = "Very Active"
    var id: Self { self }
}

enum Goal: String, Codable, CaseIterable, Identifiable {
    case loseWeight = "Lose Weight"
    case loseWeightMore = "Lose Weight (Aggressive)"
    case maintainWeight = "Maintain Weight"
    case gainWeight = "Gain Weight"
    case gainWeightMore = "Gain Weight (Aggressive)"
    var id: Self { self }
}


@Model
final class UserProfile {
    // --- Stored Properties ---
    var age: Int
    var gender: Gender
    var height: Double // in cm
    var currentWeight: Double // in kg
    var activityLevel: ActivityLevel
    var goal: Goal
    var goalWeight: Double // in kg
    var proteinTarget: Int
    var carbsTarget: Int
    var fatsTarget: Int

    // --- Transient (Calculated) Properties ---
    
    @Transient // Ignore this property for database storage
    var bmr: Double {
        let weightInKg = currentWeight
        let heightInCm = height
        if gender == .male {
            return 88.362 + (13.397 * weightInKg) + (4.799 * heightInCm) - (5.677 * Double(age))
        } else {
            return 447.593 + (9.247 * weightInKg) + (3.098 * heightInCm) - (4.330 * Double(age))
        }
    }

    @Transient // Ignore this property for database storage
    var tdee: Double {
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

    @Transient // Ignore this property for database storage
    var recommendedCalories: Int {
        switch goal {
        case .loseWeight:
            return Int(tdee - 500)
        case .loseWeightMore:
            return Int(tdee - 1000)
        case .maintainWeight:
            return Int(tdee)
        case .gainWeight:
            return Int(tdee + 500)
        case .gainWeightMore:
            return Int(tdee + 1000)
        }
    }
    
    // --- Initializer ---
    init(age: Int = 30, gender: Gender = .preferNotToSay, height: Double = 175, currentWeight: Double = 75, activityLevel: ActivityLevel = .lightlyActive, goal: Goal = .maintainWeight, goalWeight: Double = 75) {
        self.age = age
        self.gender = gender
        self.height = height
        self.currentWeight = currentWeight
        self.activityLevel = activityLevel
        self.goal = goal
        self.goalWeight = goalWeight
        
        // Default macro targets
        self.proteinTarget = 0
        self.carbsTarget = 0
        self.fatsTarget = 0
        
        // Now we can calculate and assign the real macro targets
        self.recalculateMacroTargets()
    }
    
    // A helper function to set macro targets
    func recalculateMacroTargets() {
        let totalCalories = self.recommendedCalories
        self.carbsTarget = Int((Double(totalCalories) * 0.40) / 4)
        self.proteinTarget = Int((Double(totalCalories) * 0.30) / 4)
        self.fatsTarget = Int((Double(totalCalories) * 0.30) / 9)
    }
}

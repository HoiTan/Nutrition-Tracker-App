//
//  DashboardView.swift
//  Nutrition-Tracker-App
//
//  Created by Hoi Mau Tan on 9/22/25.
//
import SwiftUI

struct DashboardView: View {
    // These would be @State properties updated as the user logs food.
    @State private var caloriesLogged: Double = 550 // Example
    @State private var targetCalories: Double = 2100

    // Calculated remaining calories
    var caloriesLeft: Int {
        Int(targetCalories - caloriesLogged)
    }
    
    // Progress for calories (0.0 to 1.0)
    var calorieProgress: Double {
        caloriesLogged / targetCalories
    }
    
    // Example Macro Data
    @State private var proteinLogged: Double = 60
    @State private var proteinTarget: Double = 150
    @State private var carbsLogged: Double = 80
    @State private var carbsTarget: Double = 250
    @State private var fatsLogged: Double = 30
    @State private var fatsTarget: Double = 80

    var body: some View {
        ZStack {
            CustomGradientBackground() // Apply the custom gradient

            VStack {
                // Header (Today, September 22)
                Text("Today, \(Date().formatted(date: .abbreviated, time: .omitted))")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 20)

                // Calorie Ring
                ZStack {
                    Circle()
                        .stroke(lineWidth: 15.0)
                        .opacity(0.3)
                        .foregroundColor(.white) // White for background ring
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(min(calorieProgress, 1.0)))
                        .stroke(style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
                        .foregroundColor(.white) // White for progress
                        .rotationEffect(Angle(degrees: 270.0))
                        .animation(.linear, value: caloriesLogged) // Animate progress

                    VStack {
                        Text("\(caloriesLeft)")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                        Text("LEFT")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .frame(width: 180, height: 180)
                .padding(.vertical, 10)
                
                // Macronutrient Bars
                VStack(alignment: .leading) {
                    HStack {
                        Text("Protein")
                        Spacer()
                        Text("\(Int(proteinLogged))g / \(Int(proteinTarget))g")
                    }
                    // Use SwiftUI.ProgressView here
                    SwiftUI.ProgressView(value: proteinLogged, total: proteinTarget)
                        .tint(.white) // White progress bar
                    
                    HStack {
                        Text("Carbs")
                        Spacer()
                        Text("\(Int(carbsLogged))g / \(Int(carbsTarget))g")
                    }
                    // And here
                    SwiftUI.ProgressView(value: carbsLogged, total: carbsTarget)
                        .tint(.white) // White progress bar

                    HStack {
                        Text("Fats")
                        Spacer()
                        Text("\(Int(fatsLogged))g / \(Int(fatsTarget))g")
                    }
                    // And here
                    SwiftUI.ProgressView(value: fatsLogged, total: fatsTarget)
                        .tint(.white) // White progress bar

                }
                .foregroundColor(.white) // White text for macros
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
                
                // Food Log List - This will scroll
                ScrollView {
                    VStack {
                        MealSectionView(mealType: "Breakfast", foodItems: [
                            FoodLogItem(name: "Oatmeal with Berries", calories: 350, protein: 10, carbs: 50, fat: 5),
                            FoodLogItem(name: "Coffee", calories: 10, protein: 0, carbs: 2, fat: 0)
                        ])
                        MealSectionView(mealType: "Lunch", foodItems: [
                            FoodLogItem(name: "Grilled Chicken Salad", calories: 480, protein: 40, carbs: 20, fat: 25)
                        ])
                        MealSectionView(mealType: "Dinner", foodItems: [])
                        MealSectionView(mealType: "Snacks", foodItems: [])
                    }
                }
                .background(Color.white) // White background for the scrollable list
                .cornerRadius(30, corners: [.topLeft, .topRight]) // Rounded top corners
                .edgesIgnoringSafeArea(.bottom) // Extend the white background to the very bottom
            }
        }
        .navigationBarHidden(true) // Hide default navigation bar to use our custom gradient top
    }
}

// Helper for rounding specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// Data model for food log item
struct FoodLogItem: Identifiable {
    let id = UUID()
    let name: String
    let calories: Int
    let protein: Int
    let carbs: Int
    let fat: Int
}

// Reusable view for each meal section
struct MealSectionView: View {
    let mealType: String
    let foodItems: [FoodLogItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(mealType)
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: { /* Add food to this meal */ }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.accentColor)
                        .font(.title3)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            ForEach(foodItems) { item in
                HStack {
                    Image("food_placeholder") // You'll need actual food images
                        .resizable()
                        .frame(width: 40, height: 40)
                        .cornerRadius(8)
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.subheadline)
                            .lineLimit(1)
                        Text("\(item.protein)g P / \(item.carbs)g C / \(item.fat)g F")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text("\(item.calories) kcal")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Image(systemName: "plus.circle") // Add this item again button
                        .foregroundColor(.accentColor)
                }
                .padding(.horizontal)
                .padding(.vertical, 4)
                Divider() // Separator line
            }
            if foodItems.isEmpty {
                Text("No items logged yet.")
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
            }
        }
        .background(Color.white)
        // No explicit corner radius here, as the ScrollView's background already handled it
    }
}

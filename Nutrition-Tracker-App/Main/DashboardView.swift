//
//  DashboardView.swift
//  Nutrition-Tracker-App
//
//  Created by Hoi Mau Tan on 9/22/25.
//
import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    
    // 1. CALCULATE the date range before the query
    private static let startOfToday = Calendar.current.startOfDay(for: .now)
    private static let startOfTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: startOfToday)!

    // 2. USE the constants in a single-line predicate
    @Query(filter: #Predicate<FoodLogItem> {
        $0.timestamp >= startOfToday && $0.timestamp < startOfTomorrow
    }, sort: \.timestamp, order: .reverse)
    private var todaysLog: [FoodLogItem]
    
    // --- Calculated Properties based on the Query ---

    @Query var profiles: [UserProfile]
    
    private var userProfile: UserProfile? {
        profiles.first
    }

    private var caloriesLogged: Double {
        todaysLog.reduce(0) { $0 + Double($1.calories) }
    }
    
    private var proteinLogged: Double {
        todaysLog.reduce(0) { $0 + Double($1.protein) }
    }
    
    private var carbsLogged: Double {
        todaysLog.reduce(0) { $0 + Double($1.carbs) }
    }

    private var fatsLogged: Double {
        todaysLog.reduce(0) { $0 + Double($1.fat) }
    }
    var caloriesLeft: Int {
        Int(targetCalories - caloriesLogged)
    }
    
    // Progress for calories (0.0 to 1.0)
    var calorieProgress: Double {
        // Ensure we don't divide by zero and cap the progress at 1.0
        guard targetCalories > 0 else { return 0 }
        return min(caloriesLogged / targetCalories, 1.0)
    }
    
    private var targetCalories: Double {
        Double(userProfile?.recommendedCalories ?? 2100)
    }
    
    private var proteinTarget: Double {
        Double(userProfile?.proteinTarget ?? 150)
    }
    
    private var carbsTarget: Double {
        Double(userProfile?.carbsTarget ?? 250)
    }

    private var fatsTarget: Double {
        Double(userProfile?.fatsTarget ?? 80)
    }


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
                
                // Food Log List Container
                VStack() {
                    // Centered Header
                    Text("Today's Log")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top)

                    // The Scrollable List
                    ScrollView {
                        // MealSectionView no longer needs the mealType
                        MealSectionView(foodItems: todaysLog)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(30, corners: [.topLeft, .topRight])
                .edgesIgnoringSafeArea(.bottom)
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
// In DashboardView.swift

// Reusable view for each meal section
struct MealSectionView: View {
    @Environment(\.modelContext) private var modelContext
    
    // Remove the mealType property
    // let mealType: String
    
    let foodItems: [FoodLogItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            ForEach(foodItems) { item in
                FoodLogRow(item: item)
                    .swipeActions {
                        Button(role: .destructive) {
                            deleteItem(item)
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    }
            }
            
            if foodItems.isEmpty {
                Text("No items logged yet for today.")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
    }
    
    private func deleteItem(_ item: FoodLogItem) {
        modelContext.delete(item)
    }
}

// A new, reusable view for a single food log row
struct FoodLogRow: View {
    let item: FoodLogItem
    
    var body: some View {
        VStack {
            HStack {
                // Placeholder image
                Image(systemName: "fork.knife.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.accentColor)
                    .frame(width: 40, height: 40)
                    
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.subheadline)
                        .lineLimit(1)
                    Text("\(item.protein)g Prot / \(item.carbs)g Carb / \(item.fat)g Fat")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("\(item.calories) kcal")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
            Divider()
        }
    }
}

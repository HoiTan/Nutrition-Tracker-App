//
//  LogFoodView.swift
//  Nutrition-Tracker-App
//
//  Created by Hoi Mau Tan on 9/22/25.
//

import SwiftUI

struct LogFoodView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @State private var selectedLogTab: Int = 0 // For the "Frequent", "My Meals", "My Foods" tabs
    
    // Example food items for the tabs
    let frequentFoods = [
        FoodLogItem(name: "Grilled Chicken Salad", calories: 380, protein: 35, carbs: 15, fat: 20),
        FoodLogItem(name: "Avocado Toast", calories: 280, protein: 10, carbs: 30, fat: 15),
        FoodLogItem(name: "Protein Shake", calories: 180, protein: 25, carbs: 10, fat: 5)
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Scan Meal with Camera button
                Button(action: { /* TODO: Implement AI Camera Scan */ }) {
                    Label("Scan Meal with Camera", systemImage: "camera.viewfinder")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(GradientButtonStyle()) // Apply gradient style
                .padding(.horizontal)

                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search for food...", text: $searchText)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

                // Scan a Barcode button
                Button(action: { /* TODO: Implement Barcode Scan */ }) {
                    Label("Scan a Barcode", systemImage: "barcode.viewfinder")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(15)
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                
                // Saved Foods Tabs (Segmented Picker acting as tabs)
                Picker("", selection: $selectedLogTab) {
                    Text("Frequent").tag(0)
                    Text("My Meals").tag(1)
                    Text("My Foods").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Content for the selected tab
                List {
                    ForEach(frequentFoods) { item in
                        HStack {
                            Image("food_placeholder") // You'll need actual food images
                                .resizable()
                                .frame(width: 40, height: 40)
                                .cornerRadius(8)
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.subheadline)
                                    .lineLimit(1)
                                Text("\(item.calories) kcal")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Button(action: { /* Add this food to log */ }) {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.accentColor)
                                    .font(.title3)
                            }
                        }
                    }
                }
                .listStyle(.plain) // Remove default list styling
                
                Spacer()
            }
            .navigationTitle("Log Food")
            .navigationBarTitleDisplayMode(.inline) // Make title smaller
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

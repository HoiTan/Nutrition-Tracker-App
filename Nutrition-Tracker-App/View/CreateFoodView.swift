//
//  CreateFoodView.swift
//  Nutrition-Tracker-App
//
//  Created by Hoi Mau Tan on 9/23/25.
//

import SwiftUI
import SwiftData

struct CreateFoodView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    // State variables to hold the user's input
    @State private var name: String = ""
    @State private var calories: Int?
    @State private var protein: Int?
    @State private var carbs: Int?
    @State private var fat: Int?
    
    // Check if the form is valid to enable the Save button
    private var isFormValid: Bool {
        !name.isEmpty && calories != nil && protein != nil && carbs != nil && fat != nil
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Food Details")) {
                    TextField("Food Name (e.g., Apple)", text: $name)
                }
                
                Section(header: Text("Nutritional Information (per serving)")) {
                    TextField("Calories (kcal)", value: $calories, format: .number)
                        .keyboardType(.numberPad)
                    
                    TextField("Protein (g)", value: $protein, format: .number)
                        .keyboardType(.numberPad)

                    TextField("Carbs (g)", value: $carbs, format: .number)
                        .keyboardType(.numberPad)

                    TextField("Fat (g)", value: $fat, format: .number)
                        .keyboardType(.numberPad)
                }
                
                Section {
                    Button("Save and Log Food") {
                        saveFood()
                    }
                    // Disable the button if the form isn't completely filled out
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("Create Custom Food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    private func saveFood() {
        guard let calories, let protein, let carbs, let fat else { return }
        
        let newItem = FoodLogItem(
            name: name,
            calories: calories,
            protein: protein,
            carbs: carbs,
            fat: fat,
            timestamp: .now
        )
        
        modelContext.insert(newItem)
        dismiss()
    }
}

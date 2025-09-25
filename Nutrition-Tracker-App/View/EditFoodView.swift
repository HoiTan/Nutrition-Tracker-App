//
//  CreateFoodView.swift
//  Nutrition-Tracker-App
//
//  Created by Hoi Mau Tan on 9/23/25.
//

import SwiftUI
import SwiftData

struct EditFoodView: View {
    @Environment(\.dismiss) var dismiss
    
    // The FoodLogItem to edit. If this is a new item, it's created in the view's initializer.
    @Bindable var item: FoodLogItem
    
    // A separate state for the serving Stepper to avoid UI glitches
    @State private var servingSize: Double

    init(item: FoodLogItem) {
        self.item = item
        _servingSize = State(initialValue: item.servings)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Food Details")) {
                    TextField("Food Name", text: $item.name)
                }
                
                Section(header: Text("Servings")) {
                    Stepper("\(servingSize, specifier: "%.2f") servings", value: $servingSize, in: 0.25...20, step: 0.25)
                }
                
                Section(header: Text("Nutritional Information (per single serving)")) {
                    TextField("Calories (kcal)", value: $item.calories, format: .number)
                        .keyboardType(.numberPad)
                    
                    TextField("Protein (g)", value: $item.protein, format: .number)
                        .keyboardType(.numberPad)

                    TextField("Carbs (g)", value: $item.carbs, format: .number)
                        .keyboardType(.numberPad)

                    TextField("Fat (g)", value: $item.fat, format: .number)
                        .keyboardType(.numberPad)
                }
                
                Section {
                    Button("Save Changes") {
                        // Update the item's servings before dismissing
                        item.servings = servingSize
                        dismiss()
                    }
                }
            }
            .navigationTitle(item.name.isEmpty ? "Log New Food" : "Edit Food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

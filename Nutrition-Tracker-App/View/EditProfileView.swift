//
//  EditProfileView.swift
//  Nutrition-Tracker-App
//
//  Created by Hoi Mau Tan on 9/26/25.
//

import SwiftUI
import SwiftData

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var userProfile: UserProfile

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Details")) {
                    TextField("Age", value: $userProfile.age, format: .number)
                        .keyboardType(.numberPad)
                    
                    Picker("Gender", selection: $userProfile.gender) {
                        ForEach(Gender.allCases) { gender in
                            Text(gender.rawValue).tag(gender)
                        }
                    }
                    
                    TextField("Height (cm)", value: $userProfile.height, format: .number)
                        .keyboardType(.decimalPad)

                    TextField("Current Weight (kg)", value: $userProfile.currentWeight, format: .number)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("Activity Level")) {
                    Picker("Activity Level", selection: $userProfile.activityLevel) {
                        ForEach(ActivityLevel.allCases) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                }

                Section(header: Text("Goal")) {
                    Picker("Goal", selection: $userProfile.goal) {
                        ForEach(Goal.allCases) { goal in
                            Text(goal.rawValue).tag(goal)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    TextField("Goal Weight (kg)", value: $userProfile.goalWeight, format: .number)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        userProfile.recalculateMacroTargets()
                        // The changes are automatically saved thanks to @Bindable
                        dismiss()
                    }
                }
            }
        }
    }
}

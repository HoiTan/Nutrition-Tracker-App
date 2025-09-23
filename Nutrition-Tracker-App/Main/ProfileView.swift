//
//  ProfileView.swift
//  Nutrition-Tracker-App
//
//  Created by Hoi Mau Tan on 9/23/25.
//

import SwiftUI

struct ProfileView: View {
    @State private var isHealthKitEnabled = true

    var body: some View {
        NavigationView {
            Form {
                // Section for basic user info
                Section(header: Text("User Details")) {
                    HStack {
                        Text("Age")
                        Spacer()
                        Text("30 years")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Height")
                        Spacer()
                        Text("175 cm")
                            .foregroundColor(.secondary)
                    }
                }

                // Section for managing goals
                Section(header: Text("My Goals")) {
                    NavigationLink("Edit Goal Weight & Activity") {
                        // The destination view would be your GoalView from onboarding
                        // but adapted for editing instead of initial setup.
                        Text("Editing Goal View Placeholder")
                    }
                }

                // Section for managing saved foods and recipes
                Section(header: Text("My Library")) {
                    NavigationLink("My Foods") {
                        Text("A list of your custom foods would go here.")
                    }
                    NavigationLink("My Recipes") {
                        Text("A list of your saved recipes would go here.")
                    }
                }

                // Section for third-party integrations
                Section(header: Text("Integrations")) {
                    Toggle("Apple Health Sync", isOn: $isHealthKitEnabled)
                        // TODO: Add logic to handle HealthKit authorization and data syncing
                }

                // Section for general app settings
                Section(header: Text("Settings")) {
                    NavigationLink("Notifications") {
                        Text("Notification settings screen.")
                    }
                    NavigationLink("Help & Support") {
                        Text("Help and support resources.")
                    }
                    NavigationLink("Privacy Policy") {
                        Text("Your app's privacy policy.")
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

//
//  ProfileView.swift
//  Nutrition-Tracker-App
//
//  Created by Hoi Mau Tan on 9/23/25.

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var profiles: [UserProfile]
    @State private var isHealthKitEnabled = true
    @State private var isEditingProfile = false

    private var userProfile: UserProfile? {
        profiles.first
    }

    var body: some View {
        NavigationView {
            if let userProfile = userProfile {
                Form {
                    // Section for basic user info
                    Section(header: Text("User Details")) {
                        HStack {
                            Text("Age")
                            Spacer()
                            Text("\(userProfile.age) years")
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text("Height")
                            Spacer()
                            Text("\(userProfile.height, specifier: "%.1f") cm")
                                .foregroundColor(.secondary)
                        }
                         HStack {
                            Text("Weight")
                            Spacer()
                            Text("\(userProfile.currentWeight, specifier: "%.1f") kg")
                                .foregroundColor(.secondary)
                        }
                    }

                    // Section for managing goals
                    Section(header: Text("My Goals")) {
                        HStack {
                            Text("Goal")
                            Spacer()
                            Text(userProfile.goal.rawValue)
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text("Goal Weight")
                            Spacer()
                            Text("\(userProfile.goalWeight, specifier: "%.1f") kg")
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text("Activity Level")
                            Spacer()
                            Text(userProfile.activityLevel.rawValue)
                                .foregroundColor(.secondary)
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
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Edit") {
                            isEditingProfile = true
                        }
                    }
                }
                .sheet(isPresented: $isEditingProfile) {
                    EditProfileView(userProfile: userProfile)
                }
            } else {
                Text("No user profile found.")
                    .navigationTitle("Profile")
            }
        }
    }
}

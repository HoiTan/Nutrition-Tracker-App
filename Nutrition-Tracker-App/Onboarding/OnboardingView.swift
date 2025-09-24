//
//  OnboardingView.swift
//  Nutrition-Tracker-App
//
//  Created by Hoi Mau Tan on 9/22/25.
//

import SwiftUI
import SwiftData
import Observation

struct OnboardingView: View {
    // Own the SwiftData model instance with @State (use @Bindable in children)
    @State private var userProfile = UserProfile()
    
    @State private var currentStep = 0

    var body: some View {
        TabView(selection: $currentStep) {
            WelcomeView(currentStep: $currentStep).tag(0)
            PersonalDetailsView(userProfile: userProfile, currentStep: $currentStep).tag(1)
            ActivityLevelView(userProfile: userProfile, currentStep: $currentStep).tag(2)
            GoalView(userProfile: userProfile, currentStep: $currentStep).tag(3)
            SummaryView(userProfile: userProfile).tag(4)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .animation(.easeInOut, value: currentStep)
    }
}

// Screen 1: Welcome
struct WelcomeView: View {
    @Binding var currentStep: Int
    var body: some View {
        ZStack { // Add ZStack for the background
            CustomGradientBackground() // Apply the custom gradient
            VStack(spacing: 20) {
                Spacer()
                Text("Welcome to NutriAI")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white) // Change text color for contrast
                Text("Effortlessly track your nutrition with AI.")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8)) // Adjust opacity
                Spacer()
                Button("Get Started") {
                    currentStep = 1
                }
                .buttonStyle(GradientButtonStyle()) // Use custom button style
                .padding()
            }
        }
    }
}

// Screen 2: Personal Details
struct PersonalDetailsView: View {
    @Bindable var userProfile: UserProfile
    @Binding var currentStep: Int
    
    var body: some View {
        ZStack {
            CustomGradientBackground()

            VStack {
                Text("Tell us about you")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                Form {
                    Section(header: Text("Personal Details").foregroundColor(.white.opacity(0.7))) {
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
                    .listRowBackground(Color.white.opacity(0.1)) // Makes rows slightly opaque
                    .foregroundColor(.white) // Sets text color for Picker and TextField
                }
                .scrollContentBackground(.hidden) // Hides default form background
                
                Button("Next") { currentStep = 2 }
                    .buttonStyle(GradientButtonStyle())
                    .padding()
            }
        }
    }
}

// Screen 3: Activity Level
struct ActivityLevelView: View {
    @Bindable var userProfile: UserProfile
    @Binding var currentStep: Int

    var body: some View {
        ZStack {
            CustomGradientBackground()
            
            VStack {
                Text("How active are you?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)

                Form {
                    Section {
                        Picker("Activity Level", selection: $userProfile.activityLevel) {
                            ForEach(ActivityLevel.allCases) { level in
                                Text(level.rawValue).tag(level)
                            }
                        }
                        .pickerStyle(.inline)
                        .labelsHidden()
                    }
                    .listRowBackground(Color.white.opacity(0.1))
                    .foregroundColor(.white)
                }
                .scrollContentBackground(.hidden)

                Button("Next") { currentStep = 3 }
                    .buttonStyle(GradientButtonStyle())
                    .padding()
            }
        }
    }
}

// Screen 4: Define Your Goal
struct GoalView: View {
    @Bindable var userProfile: UserProfile
    @Binding var currentStep: Int

    var body: some View {
        ZStack {
            CustomGradientBackground()
            
            VStack {
                Text("What's your goal?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)

                Form {
                    Section(header: Text("Goal Type").foregroundColor(.white.opacity(0.7))) {
                        Picker("Goal", selection: $userProfile.goal) {
                            ForEach(Goal.allCases) { goal in
                                Text(goal.rawValue).tag(goal)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .listRowBackground(Color.white.opacity(0.1))

                    Section(header: Text("Target Weight").foregroundColor(.white.opacity(0.7))) {
                         TextField("Goal Weight (kg)", value: $userProfile.goalWeight, format: .number)
                            .keyboardType(.decimalPad)
                            .foregroundColor(.white)
                    }
                     .listRowBackground(Color.white.opacity(0.1))
                }
                .scrollContentBackground(.hidden)

                Button("Next") { currentStep = 4 }
                    .buttonStyle(GradientButtonStyle())
                    .padding()
            }
        }
    }
}


// Screen 5: Summary & Calorie Target
struct SummaryView: View {
    // Get access to the database context from the environment
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var userProfile: UserProfile

    var body: some View {
        ZStack {
            CustomGradientBackground()
            
            VStack(spacing: 30) {
                Spacer()
                
                Text("You're all set!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Based on your profile, we recommend a daily target of:")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("\(userProfile.recommendedCalories)")
                        .font(.system(size: 60, weight: .bold))
                    Text(" calories")
                        .font(.title)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Text("🎯")
                    .font(.system(size: 80))

                Spacer()
                Spacer()
                
                Button("Let's Go!") {
                    // Save userProfile to SwiftData
                    saveProfile()
                }
                .buttonStyle(GradientButtonStyle())
                .padding()
            }
            .foregroundColor(.white) // Apply to all text in the VStack
        }
    }
    private func saveProfile() {
        modelContext.insert(userProfile)
    }
}

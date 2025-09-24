//
//  ContentView.swift
//  Nutrition-Tracker-App
//
//  Created by Hoi Mau Tan on 9/22/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // This query automatically fetches UserProfile data from the database.
    // The 'profiles' array will be empty if no profile has been saved yet.
    @Query var profiles: [UserProfile]
    
    var body: some View {
        // If there is no profile saved, show the OnboardingView.
        // Otherwise, show the MainTabView.
        if profiles.isEmpty {
            // Note: OnboardingView now manages its own state
            OnboardingView()
        } else {
            MainTabView()
        }
    }
}

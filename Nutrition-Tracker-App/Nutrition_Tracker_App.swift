//
//  Nutrition_Tracker_AppApp.swift
//  Nutrition-Tracker-App
//
//  Created by Hoi Mau Tan on 9/22/25.
//
import SwiftUI
import SwiftData

@main
struct Nutrition_Tracker_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // This sets up the database for the entire app
        .modelContainer(for: [UserProfile.self, FoodLogItem.self])
    }
}

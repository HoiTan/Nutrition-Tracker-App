//
//  Nutrition_Tracker_AppApp.swift
//  Nutrition-Tracker-App
//
//  Created by Hoi Mau Tan on 9/22/25.
//

import SwiftUI

@main
struct Nutrition_Tracker_AppApp: App {
    @AppStorage("isOnboardingComplete") var isOnboardingComplete: Bool = false

    var body: some Scene {
        WindowGroup {
            if isOnboardingComplete {
                MainTabView()
            } else {
                OnboardingView(isOnboardingComplete: $isOnboardingComplete)
            }
        }
    }
}

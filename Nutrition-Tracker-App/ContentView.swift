//
//  ContentView.swift
//  Nutrition-Tracker-App
//
//  Created by Hoi Mau Tan on 9/22/25.
//
// ContentView.swift

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query var profiles: [UserProfile]
    
    // Get the manager from the environment
    @EnvironmentObject var deepLinkManager: DeepLinkManager
    
    var body: some View {
        // Wrap the logic in a Group
        Group {
            if profiles.isEmpty {
                OnboardingView()
            } else {
                MainTabView()
            }
        }
        // Attach the modifier to the Group
        .onOpenURL { url in
            print("✅ 1. ContentView: Received URL - \(url)")
            if url.scheme == "foodlog" && url.host == "scanmeal" {
                print("✅ 2. ContentView: URL Matched! Setting deep link.")
                deepLinkManager.pendingDeepLink = .scanMeal
            }
        }
    }
}

//
//  MainTabView.swift
//  Nutrition-Tracker-App
//
//  Created by Hoi Mau Tan on 9/22/25.
//

import SwiftUI

// MARK: - MainTabView

struct MainTabView: View {
    @State private var selectedTab: Tab = .today
    @State private var isLoggingFood = false // Controls the food logging modal
    
    // Enum to define our tabs
    enum Tab: String {
        case today = "Today"
        case progress = "Progress"
        case profile = "Profile"
    }

    var body: some View {
        ZStack {
            // Content of the selected tab
            VStack {
                switch selectedTab {
                case .today:
                    DashboardView()
                case .progress:
                    ProgressView() // Placeholder, you'll implement this later
                case .profile:
                    ProfileView() // Placeholder, you'll implement this later
                }
            }
            // Ensure content doesn't go under the custom tab bar
            .padding(.bottom, 80) // Adjust based on your custom tab bar's height

            // Our Custom Tab Bar
            VStack {
                Spacer()
                CustomTabBarView(selectedTab: $selectedTab, isLoggingFood: $isLoggingFood)
            }
            .edgesIgnoringSafeArea(.bottom) // Allow tab bar to go to the very bottom
        }
        .sheet(isPresented: $isLoggingFood) {
            // This is the modal sheet for logging food
            LogFoodView()
        }
    }
}

// MARK: - CustomTabBarView

struct CustomTabBarView: View {
    @Binding var selectedTab: MainTabView.Tab
    @Binding var isLoggingFood: Bool

    var body: some View {
        HStack {
            // Today Tab
            Spacer()
            TabBarButton(tab: .today, selectedTab: $selectedTab, systemImage: "house.fill")
            Spacer()

            // Central Log Button
            Button(action: {
                isLoggingFood = true
            }) {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(15)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.accentGradientStart, .accentGradientEnd]), startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(Circle())
                    .shadow(radius: 8)
            }
            .offset(y: -15) // Lift the button slightly
            
            // Progress Tab
            Spacer()
            TabBarButton(tab: .progress, selectedTab: $selectedTab, systemImage: "chart.bar.xaxis")
            Spacer()

            // Profile Tab
            TabBarButton(tab: .profile, selectedTab: $selectedTab, systemImage: "person.fill")
            Spacer()
        }
        .frame(height: 70) // Height of the custom tab bar
        .background(Color.white) // Background for the tab bar
        .cornerRadius(30)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}

// MARK: - TabBarButton

struct TabBarButton: View {
    let tab: MainTabView.Tab
    @Binding var selectedTab: MainTabView.Tab
    let systemImage: String

    var body: some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack {
                Image(systemName: systemImage)
                    .font(.title2)
                Text(tab.rawValue)
                    .font(.caption)
            }
            .foregroundColor(selectedTab == tab ? .accentColor : .gray)
        }
    }
}

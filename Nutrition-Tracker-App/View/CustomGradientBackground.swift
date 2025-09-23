//
//  CustomGradientBackground.swift
//  Nutrition-Tracker-App
//
//  Created by Hoi Mau Tan on 9/22/25.
//

import SwiftUI

struct CustomGradientBackground: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [
            Color(red: 0.60, green: 0.90, blue: 0.60), // Lighter green at the top
            Color(red: 0.30, green: 0.80, blue: 0.70)  // Teal/aqua in the middle
        ]), startPoint: .top, endPoint: .bottom)
        .edgesIgnoringSafeArea(.all) // Extends gradient to full screen
    }
}

// You can also define your main app accent color here for consistency
extension Color {
    static let primaryGradientStart = Color(red: 0.60, green: 0.90, blue: 0.60)
    static let primaryGradientEnd = Color(red: 0.30, green: 0.80, blue: 0.70)
    static let accentGradientStart = Color(red: 0.30, green: 0.80, blue: 0.70)
    static let accentGradientEnd = Color(red: 0.20, green: 0.70, blue: 0.90) // More blue
}

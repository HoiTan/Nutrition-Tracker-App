//
//  DeepLinkManager.swift
//  Nutrition-Tracker-App
//
//  Created by Hoi Mau Tan on 9/25/25.
//


import Foundation
import Combine

// An enum to represent the different actions your app can handle.
enum DeepLink: String {
    case scanMeal
}

// This object will be shared across your app to manage deep links.
class DeepLinkManager: ObservableObject {
    @Published var pendingDeepLink: DeepLink? = nil
}

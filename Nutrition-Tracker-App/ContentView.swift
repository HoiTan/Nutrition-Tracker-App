//
//  ContentView.swift
//  Nutrition-Tracker-App
//
//  Created by Hoi Mau Tan on 9/22/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, from my first app!")
                .font(.largeTitle) // Add this line
                .foregroundStyle(.blue) // And this one
        }
        .padding()
    }
}



#Preview {
    ContentView()
}

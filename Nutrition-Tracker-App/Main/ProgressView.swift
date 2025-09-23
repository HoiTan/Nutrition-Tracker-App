//
//  ProgressView.swift
//  Nutrition-Tracker-App
//
//  Created by Hoi Mau Tan on 9/23/25.
//

import SwiftUI
import Charts // Make sure to import the Charts framework

// MARK: - Main Progress View

struct ProgressView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        NavigationView {
            VStack {
                Picker("Progress", selection: $selectedTab) {
                    Text("Weight").tag(0)
                    Text("History").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if selectedTab == 0 {
                    WeightProgressView()
                } else {
                    HistoryProgressView()
                }
                Spacer()
            }
            .navigationTitle("Progress")
        }
    }
}

// MARK: - Weight Log Data Model (for sample data)

struct WeightLog: Identifiable {
    let id = UUID()
    let date: Date
    let weightKg: Double
}

// MARK: - Weight Progress View

struct WeightProgressView: View {
    @State private var isLoggingWeight = false
    
    // Sample data for the chart
    let weightData: [WeightLog] = [
        .init(date: Date.from(year: 2025, month: 8, day: 1), weightKg: 80.0),
        .init(date: Date.from(year: 2025, month: 8, day: 8), weightKg: 79.5),
        .init(date: Date.from(year: 2025, month: 8, day: 15), weightKg: 79.8),
        .init(date: Date.from(year: 2025, month: 9, day: 1), weightKg: 78.5),
        .init(date: Date.from(year: 2025, month: 9, day: 8), weightKg: 78.2),
        .init(date: Date.from(year: 2025, month: 9, day: 15), weightKg: 77.5),
        .init(date: Date.from(year: 2025, month: 9, day: 22), weightKg: 77.6)
    ]
    
    let goalWeight: Double = 75.0

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                Chart {
                    // Line for the user's weight
                    ForEach(weightData) { log in
                        LineMark(
                            x: .value("Date", log.date),
                            y: .value("Weight (kg)", log.weightKg)
                        )
                        .foregroundStyle(Color.accentColor)
                        .symbol(Circle().strokeBorder(lineWidth: 2))
                    }
                    
                    // Horizontal line for the goal weight
                    RuleMark(y: .value("Goal", goalWeight))
                        .foregroundStyle(.green)
                        .annotation(position: .top, alignment: .leading) {
                            Text("Goal: \(goalWeight, specifier: "%.1f") kg")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .weekOfYear)) { _ in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .dateTime.month().day())
                    }
                }
                .padding()

                Text("Weight Trend Chart")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            // Floating Action Button
            Button(action: { isLoggingWeight = true }) {
                Image(systemName: "plus")
                    .font(.title.weight(.semibold))
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .padding()
        }
        .sheet(isPresented: $isLoggingWeight) {
            LogWeightView()
        }
    }
}

// MARK: - History Progress View

struct HistoryProgressView: View {
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack {
            // This is a native calendar view.
            // To add dots for logged days, you'd need to build a custom calendar
            // or use a third-party library.
            DatePicker(
                "Food Log History",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .padding()
            
            Text("Selected: \(selectedDate.formatted(date: .long, time: .omitted))")
            Text("Tapping a date would show a read-only food log here.")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

// MARK: - Log Weight Modal View

struct LogWeightView: View {
    @Environment(\.dismiss) var dismiss
    @State private var newWeight: Double = 77.0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter Your Current Weight")) {
                    TextField("Weight (kg)", value: $newWeight, format: .number)
                        .keyboardType(.decimalPad)
                }
                Button("Save Weight") {
                    // TODO: Add logic to save the new weight
                    dismiss()
                }
            }
            .navigationTitle("Log Weight")
            .navigationBarItems(leading: Button("Cancel") { dismiss() })
        }
    }
}

// MARK: - Date Helper Extension

// Helper to make creating dates for sample data easier
extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}

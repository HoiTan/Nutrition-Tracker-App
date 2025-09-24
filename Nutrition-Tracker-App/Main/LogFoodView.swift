import SwiftUI
import SwiftData

struct LogFoodView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var isCreatingFood = false
    
    @State private var searchText = ""
    @State private var selectedLogTab: Int = 0
    
    // 1. ADD THIS QUERY to fetch food history, sorted by most recent
    @Query(sort: \FoodLogItem.timestamp, order: .reverse) private var foodLogHistory: [FoodLogItem]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                Button(action: { /* TODO: Implement AI Camera Scan */ }) {
                    Label("Scan Meal with Camera", systemImage: "camera.viewfinder")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(GradientButtonStyle())
                .padding(.horizontal)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search for food...", text: $searchText)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                Button(action: { isCreatingFood = true }) {
                    Label("Create a Custom Food", systemImage: "square.and.pencil")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(15)
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                
                // Saved Foods Tabs
                Picker("", selection: $selectedLogTab) {
                    Text("Recents").tag(0) // Renamed for clarity
                    Text("My Meals").tag(1)
                    Text("My Foods").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Content for the selected tab
                List {
                    // 2. UPDATE ForEach to use the new 'foodLogHistory' query
                    ForEach(foodLogHistory) { item in
                        HStack {
                            Image(systemName: "fork.knife.circle.fill")
                                .font(.title)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.accentColor)
                            
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.subheadline)
                                    .lineLimit(1)
                                Text("\(item.calories) kcal")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            // 3. MAKE a functional button to re-log an item
                            Button(action: {
                                reLogItem(item)
                                dismiss() // Close sheet after re-logging
                            }) {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.accentColor)
                                    .font(.title3)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                
                Spacer()
            }
            .navigationTitle("Log Food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
            .sheet(isPresented: $isCreatingFood) {
                CreateFoodView()
            }
        }
    }
    
    // 4. ADD this function to re-log a food item
    private func reLogItem(_ item: FoodLogItem) {
        // Create a new item with the same data but a new timestamp
        let newItem = FoodLogItem(
            name: item.name,
            calories: item.calories,
            protein: item.protein,
            carbs: item.carbs,
            fat: item.fat,
            timestamp: .now // Set to the current time
        )
        modelContext.insert(newItem)
    }
}

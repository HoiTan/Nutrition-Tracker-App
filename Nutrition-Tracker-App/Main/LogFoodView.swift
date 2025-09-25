// LogFoodView.swift

import SwiftUI
import SwiftData

struct LogFoodView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss

    // MARK: - State and Environment
    @StateObject private var geminiService = GeminiAPIService()
    @State private var itemToCreate: FoodLogItem?
    
    // --- UPDATE THESE STATE VARIABLES ---
     @State private var isShowingImagePicker = false
     @State private var isShowingSourceOptions = false // Controls the action sheet
     @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
     // --- END OF UPDATE ---
    
    @State private var selectedImage: UIImage?
    @State private var searchText = ""
    @State private var selectedLogTab: Int = 0
    
    @Query(sort: \FoodLogItem.timestamp, order: .reverse) private var foodLogHistory: [FoodLogItem]
    
    // MARK: - Main Body
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                scanSection
                searchAndCreateSection
                recentsListSection
            }
            .navigationTitle("Log Food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(image: $selectedImage, sourceType: imagePickerSourceType)
            }
            .sheet(item: $itemToCreate) { item in
                modelContext.insert(item)
                return EditFoodView(item: item)
            }
            .actionSheet(isPresented: $isShowingSourceOptions) {
                ActionSheet(title: Text("Select Image Source"), buttons: [
                    .default(Text("Take Photo")) {
                        self.imagePickerSourceType = .camera
                        self.isShowingImagePicker = true
                    },
                    .default(Text("Choose from Library")) {
                        self.imagePickerSourceType = .photoLibrary
                        self.isShowingImagePicker = true
                    },
                    .cancel()
                ])
            }
            .onChange(of: selectedImage) {
                if let image = selectedImage {
                    geminiService.recognizeFood(from: image)
                }
            }
            .onChange(of: geminiService.recognizedFood) {
                if let foodItem = geminiService.recognizedFood {
                    self.itemToCreate = foodItem
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    private func reLogItem(_ item: FoodLogItem) {
        let newItem = FoodLogItem(
            name: item.name,
            calories: item.calories,
            protein: item.protein,
            carbs: item.carbs,
            fat: item.fat,
            timestamp: .now
        )
        modelContext.insert(newItem)
    }
}

// MARK: - UI Components (Refactored Views)
private extension LogFoodView {
    
    var scanSection: some View {
        VStack {
            Button(action: { isShowingSourceOptions = true }) { // Show options now
                Label("Scan Meal with AI Camera", systemImage: "camera.viewfinder")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(GradientButtonStyle())
            .padding(.horizontal)
            
            if geminiService.isLoading {
                SwiftUI.ProgressView("Analyzing your meal...")
                    .padding()
            } else if let errorMessage = geminiService.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    var searchAndCreateSection: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search for food...", text: $searchText)
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            Button(action: {
                itemToCreate = FoodLogItem(name: "", calories: 0, protein: 0, carbs: 0, fat: 0, timestamp: .now)
            }) {
                Label("Create a Custom Food", systemImage: "square.and.pencil")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(15)
            }
            .foregroundColor(.black)
            .padding(.horizontal)
        }
    }
    
    var recentsListSection: some View {
        VStack {
            Picker("", selection: $selectedLogTab) {
                Text("Recents").tag(0)
                Text("My Meals").tag(1)
                Text("My Foods").tag(2)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            List {
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
                        Button(action: {
                            reLogItem(item)
                            dismiss()
                        }) {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.accentColor)
                                .font(.title3)
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

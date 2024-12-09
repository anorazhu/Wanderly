import SwiftUI

struct DestinationView: View {
    @Binding var selectedTab: Int
    @Binding var selectedMood: String
    @Binding var selectedBudget: String
    @Binding var selectedDistance: Double
    
    @State private var isEditing: Bool = false
    @State private var cityViewModel = CityViewModel()
    
    var filteredDestinations: [City] {
        cityViewModel.cities.filter { city in
            let moodMatches = matchesMood(for: city)
            let distanceMatches = matchesDistance(for: city)
            return moodMatches && distanceMatches
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header Section
                HStack {
                    DestinationTitle()
                    Spacer()
                    EditButton(isEditing: $isEditing)
                        .frame(width: 100)
                }
                
                Divider()
                
                // Destination List or Loading State
                if cityViewModel.isLoading {
                    ProgressView("Loading cities...")
                        .padding()
                } else if filteredDestinations.isEmpty {
                    Text("No cities match your preferences.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 20) {
                            ForEach(filteredDestinations, id: \.name) { city in
                                NavigationLink(
                                    destination: ActivityView(
                                        destination: city.name,
                                        latitude: city.latitude,
                                        longitude: city.longitude,
                                        mood: Mood(rawValue: selectedMood), // Ensure correct Mood enum conversion
                                        budget: selectedBudget,
                                        radius: Int(selectedDistance),
                                        selectedTab: $selectedTab
                                    )
                                ) {
                                    DestinationProfileCard(city: city)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarBackButtonHidden()
            .background(Color(.systemBackground))
            .sheet(isPresented: $isEditing) {
                EditPreferencesView(
                    selectedMood: $selectedMood,
                    selectedBudget: $selectedBudget,
                    selectedDistance: $selectedDistance
                )
            }
            .task {
                // Fetch cities dynamically based on user preferences
                await cityViewModel.getData(for: "") // Adjust query if needed
            }
        }
    }
    
    private func matchesMood(for city: City) -> Bool {
        switch selectedMood {
        case "Relaxed":
            return city.population < 100_000
        case "Adventurous":
            return city.population >= 100_000 && city.population <= 500_000
        case "Cultural":
            return city.population > 500_000
        default:
            return false
        }
    }
    
    private func matchesDistance(for city: City) -> Bool {
        // Placeholder for distance calculation
        return selectedDistance >= 50.0
    }
}

struct DestinationProfileCard: View {
    let city: City
    
    var body: some View {
        VStack(alignment: .leading) {
            //            AsyncImage(url: URL(string: city.imageURL)) { image in
            //                image
            //                    .resizable()
            //                    .aspectRatio(contentMode: .fill)
            //                    .frame(maxWidth: .infinity, maxHeight: 200)
            //                    .clipped()
            //                    .cornerRadius(15)
            //            } placeholder: {
            //                ProgressView()
            //            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(city.name)
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Population: \(city.population.formatted())")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2)
    }
}

struct DestinationTitle: View {
    var body: some View {
        Text("Destination Suggestions")
            .font(.title)
            .fontWeight(.bold)
            .padding(.horizontal)
    }
}

struct EditButton: View {
    @Binding var isEditing: Bool
    
    var body: some View {
        Button(action: {
            withAnimation {
                isEditing.toggle()
            }
        }) {
            Text(isEditing ? "Done" : "Edit")
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isEditing ? Color.red : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}


struct EditPreferencesView: View {
    @Binding var selectedMood: String
    @Binding var selectedBudget: String
    @Binding var selectedDistance: Double
    
    let moods = ["Relaxed", "Adventurous", "Cultural"]
    let budgets = ["Cheap", "Moderate", "Luxury"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Edit Preferences")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Divider()
                
                // Mood Picker
                VStack(alignment: .leading, spacing: 10) {
                    Text("Mood")
                        .font(.headline)
                    Picker("Mood", selection: $selectedMood) {
                        ForEach(moods, id: \.self) { mood in
                            Text(mood).tag(mood)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.horizontal)
                
                // Budget Picker
                VStack(alignment: .leading, spacing: 10) {
                    Text("Budget")
                        .font(.headline)
                    Picker("Budget", selection: $selectedBudget) {
                        ForEach(budgets, id: \.self) { budget in
                            Text(budget).tag(budget)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.horizontal)
                
                // Distance Slider
                VStack(alignment: .leading, spacing: 10) {
                    Text("Distance")
                        .font(.headline)
                    Slider(value: $selectedDistance, in: 10...500, step: 10) {
                        Text("Distance: \(Int(selectedDistance)) km")
                    }
                    Text("\(Int(selectedDistance)) km")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button("Done") {
                    // Add logic to close the sheet
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .padding()
        }
    }
}


#Preview {
    DestinationView(
        selectedTab: .constant(1),
        selectedMood: .constant("Relaxed"),
        selectedBudget: .constant("Moderate"),
        selectedDistance: .constant(50.0)
    )
}
